require 'unirest'
require 'active_support/all'

class Fixnum
  SECONDS_IN_DAY = 24 * 60 * 60

  def days
    self * SECONDS_IN_DAY
  end

  def ago
    Time.now - self
  end
end

class PullRequest
  attr_accessor :title, :URL, :merge_date, :username

  def initialize(json)
    @title = json['title']
    @URL = json['html_url']
    @username = json['user']['login']
    @merge_date = Date.parse(json['merged_at'])
  end

  def description
    "#{merge_date.strftime('%m/%d/%Y')}: #{title} (@#{username})"
  end
end

class GitHubClient
  def initialize(options)
    @access_token = options.fetch(:access_token)
    @repositories = options.fetch(:repositories)
    @base_url = 'https://api.github.com/repos'
  end

  def get_pull_requests(days_ago)
    prs = @repositories.flat_map { |repository|
      get_json("#{repository}/pulls", {
        per_page: 50,
        state: 'closed',
        sort: 'updated',
        direction: 'desc'
      })
    }
    .select { |json|
      merge_date = json['merged_at']

      !merge_date.nil? && Time.parse(merge_date) > days_ago.days.ago
    }.map { |json|
      PullRequest.new(json)
    }
  end

  private def get_json(path, data)
    Unirest.get("#{@base_url}/#{path}", headers: {
        'Authorization' => "token #{@access_token}"
      },
      parameters: data
    ).body
  end
end
