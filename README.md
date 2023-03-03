# Custom-Action
This custom action creates a new release if found inside a commit comment the
regular expression release v[a-zA-Z0-9.]\*. It will create a release
v\<something\>

# Environment Variables
* `GITHUB_TOKEN` - _Required_ Allows the Action to authenticate with the GitHub
  API.

# Arguments
None

# Examples

```
name: custom-action

on: 
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: jmoyano/custom-action@main
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
