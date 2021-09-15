#!/usr/bin/env bash

set -euo pipefail

# shellcheck source-path=SCRIPTDIR
source "$(dirname "${BASH_SOURCE[0]}")/../lib/artifacts.sh"
# shellcheck source-path=SCRIPTDIR
source "$(dirname "${BASH_SOURCE[0]}")/../lib/packer_artifacts.sh"

# TODO: Could just use the artifacts plugin for this
download_all_packer_manifests() {
    buildkite-agent artifact download "*.${PACKER_MANIFEST_EXTENSION}" .
}

upload_all_grapl_artifacts() {
    buildkite-agent artifact upload "*.${ARTIFACTS_FILE_EXTENSION}"
}

download_all_packer_manifests

for packer_manifest_file in *."${PACKER_MANIFEST_EXTENSION}"; do
    echo -e "--- Extracting AMI information from ${packer_manifest_file}"
    slug="$(name_from_manifest_file "${packer_manifest_file}")"
    extract_ami_information "${packer_manifest_file}" > "$(artifacts_file_for "${slug}")"
done

# To keep things simple, we _could_ use the artifacts plugin, or
# artifacts_path key instead of this.
#
# Here, at least, we're keeping all the extension knowledge "in house"
upload_all_grapl_artifacts
