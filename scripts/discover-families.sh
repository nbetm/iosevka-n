#!/usr/bin/env bash
#
# Description: Emit the font families declared in private-build-plans.toml
#              as a GITHUB_OUTPUT line for the GitHub Actions matrix job
#
# Set options:
#   e: Stop script if command fails
#   u: Stop script if unset variable is referenced
#   x: Debug, print commands as they are executed
#   f: Disable file name generation (globbing).
#   o pipefail: If any command in a pipeline fails it all fails
#
set -euo pipefail

cd "$(dirname "$0")/../get-all-families-in-private-build-plan"
npm install --silent >&2
node ./index.mjs
