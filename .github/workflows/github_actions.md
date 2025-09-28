# Run GitHub Actions Locally

The most popular tool is act, which runs your GitHub Actions workflows in Docker containers locally.

Install the ``act`` tool.

MacOS:

```sh
brew install act
```

Now you can run your GitHub Actions locally:

```sh
act --list
```

## Running Specific Jobs

_Start Is the docker daemon:_
```sh
open -a Docker
act -j formatting
```

Now you can test individual jobs:
```sh
act -j pre-commit --verbose
```

Or run for all jobs:
```sh
act --verbose
```

Dry run to see what would happen
```sh
act --dryrun
```
