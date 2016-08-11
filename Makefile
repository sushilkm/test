.PHONY: help test

export CATALOG_LOCATION?=s3://helion-service-manager/release/catalog-templates/HCP-v1/stable-1/services

default: help

help:
	@echo "These 'make' targets are available."
	@echo
	@echo "  test               Run the unit tests"

all: tools test

tools:
	@echo "$(OK_COLOR)==> Getting required tools$(NO_COLOR)"
	go get github.com/tools/godep

test: tools test-format
	@echo "$(OK_COLOR)==> Testing code$(NO_COLOR)"
	SKIP_SDL_VALIDATION="hce hcf helion-console hcp" godep go test ./... -v

test-format:
	@echo "$(OK_COLOR)==> Checking code with gofmt$(NO_COLOR)"
	./scripts/testFmt.sh tests

publish-catalog:
	@echo "$(OK_COLOR)===> Publish catalog to s3 location @ ${}$(NO_COLOR)"
	./scripts/publish-catalog-bucket.sh
