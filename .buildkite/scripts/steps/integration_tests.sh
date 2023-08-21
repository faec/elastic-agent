#!/usr/bin/env bash
set -euxo pipefail

source .buildkite/scripts/common.sh

# PACKAGE
DEV=true EXTERNAL=true SNAPSHOT=true PLATFORMS=linux/amd64,linux/arm64 PACKAGES=tar.gz mage package

# Run integration tests
set +e
TEST_INTEG_CLEAN_ON_EXIT=true SNAPSHOT=true mage integration:test
TESTS_EXIT_STATUS=$?
set -e

# HTML report
go install github.com/alexec/junit2html@latest
junit2html < build/TEST-go-integration.xml > build/TEST-report.html

exit $TESTS_EXIT_STATUS
