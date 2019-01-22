# prs

A script for getting a list of PRs over a given time period

* [Usage](#usage)
* [Configuration](#configuration)

## Usage

First, run `bundle install` to install dependencies. Then:

```bash
./bin/prs --days 14            # How many days of pull requests to fetch
```

## Configuration

First, you must create a `config.yml` file that includes the following values:

```yaml
github:
  api_token: <YOUR TOKEN HERE>
  repositories: [prefer/app]
```

You can create a GitHub API token [here](https://github.com/settings/tokens).

## License

Available for use under the MIT license: [http://bryan.mit-license.org](http://bryan.mit-license.org)
