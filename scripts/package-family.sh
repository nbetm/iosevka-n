#!/usr/bin/env bash
#
# Description: Package a built family's hinted or unhinted TTF output as a flat tarball under ./dist/
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
variant="${3:?variant required (hinted|unhinted)}"

case "${variant}" in
    hinted)
        subdir="TTF"
        suffix=""
        ;;
    unhinted)
        subdir="TTF-Unhinted"
        suffix="-unhinted"
        ;;
    *)
        echo "error: variant must be 'hinted' or 'unhinted', got '${variant}'" >&2
        exit 1
        ;;
esac

src="dist/${family}/${subdir}"
out="dist/${family}${suffix}-${iosevka_version}.tar.gz"

if [[ ! -d "${src}" ]]; then
    echo "error: ${src} does not exist; run build-family.sh first" >&2
    exit 1
fi

tar -czf "${out}" -C "${src}" .
echo "${out}"
