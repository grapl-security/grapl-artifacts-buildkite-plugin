#!/usr/bin/env bash

oneTimeSetUp() {
    source lib/packer_artifacts.sh
}

test_name_from_manifest_file() {
    local -r actual="$(name_from_manifest_file foobar.packer-manifest.json)"
    local -r expected="foobar"

    assertEquals "Failed to extract name!" \
        "${expected}" \
        "${actual}"
}

test_extract_ami_information() {
    testcases=(
        multiple-runs-single-region
        single-run-single-region
        single-run-multiple-regions
    )

    for testcase in "${testcases[@]}"; do
        input_file="fixtures/${testcase}.packer-manifest.json"
        output_file="fixtures/${testcase}.grapl-artifacts.json"

        actual="$(extract_ami_information "${input_file}")"
        expected="$(jq '.' "${output_file}")"

        assertEquals "Something went wrong processing ${input_file}" \
            "${expected}" \
            "${actual}"
    done
}
