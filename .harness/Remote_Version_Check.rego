package pipeline_environment

deny[sprintf("version must be greater than v0.400.0 but is currently '%s'", [input.version])] {
    version := trim(input.version, "v")
    semver.compare(version, "1.400.0") < 0
}