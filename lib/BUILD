shell_library(
    dependencies=[":jq"]
)

resources(
    name="jq",
    sources=["*.jq"]
)

shunit2_tests(
    name="tests",
    dependencies=["fixtures"]
)
