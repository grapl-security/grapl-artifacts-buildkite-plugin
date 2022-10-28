shell_sources(dependencies=[":jq"])

resources(name="jq", sources=["*.jq"])

# Currently using relative imports for tests, which aren't visible to Pants
shunit2_tests(name="tests", dependencies=["fixtures", ":lib"])
