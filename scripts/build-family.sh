#!/usr/bin/env bash
#
# Description: Build one Iosevka font family by cloning upstream iosevka
#              at a given tag and applying our custom build plan
#
# Set options:
#   e: Stop script if command fails
#   u: Stop script if unset variable is referenced
#   x: Debug, print commands as they are executed
#   f: Disable file name generation (globbing).
#   o pipefail: If any command in a pipeline fails it all fails
#
set -euo pipefail

family="${1:?family name required}"
iosevka_version="${2:?iosevka version required}"

echo "Building ${family} against Iosevka ${iosevka_version}" >&2

orig_pwd="$(pwd)"
workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

git clone --depth 1 --branch "${iosevka_version}" \
    https://github.com/be5invis/iosevka "${workdir}/iosevka"
cp "${orig_pwd}/private-build-plans.toml" "${workdir}/iosevka/private-build-plans.toml"

cd "${workdir}/iosevka"
npm ci
npm run build -- "ttf::${family}"

# Copy build output back to a stable path.
# Remove any prior local result first so re-runs don't merge directories.
rm -rf "${orig_pwd}/dist/${family}"
mkdir -p "${orig_pwd}/dist"
cp -r "dist/${family}" "${orig_pwd}/dist/${family}"

# Bundle the OFL so tarballs ship with the license (OFL-1.1 §3).
cp LICENSE.md "${orig_pwd}/dist/${family}/TTF/OFL.txt"
