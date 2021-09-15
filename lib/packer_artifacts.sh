#!/usr/bin/env bash

set -euo pipefail

jq_filter_path="$(dirname "${BASH_SOURCE[0]}")/../lib/extract_ami_id_dict.jq"
readonly jq_filter_path
readonly PACKER_MANIFEST_EXTENSION="packer-manifest.json"

name_from_manifest_file() {
    local -r manifest_file="${1}"
    basename "${manifest_file}" ".${PACKER_MANIFEST_EXTENSION}"
}

extract_ami_information() {
    local -r manifest_file="${1}"
    local -r name="$(name_from_manifest_file "${manifest_file}")"

    jq --raw-output \
        --arg IMAGE_NAME "${name}" \
        --from-file "${jq_filter_path}" \
        "${manifest_file}"
}
