VERSION=`git rev-parse HEAD`
BUILD=`date +%FT%T%z`
LDFLAGS="-X main.Version=${VERSION} -X main.Build=${BUILD} -w -s"

.PHONY: help
help: ## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:	## - Build the golang docker image based on scratch
	@printf "\033[32m\xE2\x9c\x93 Build the golang docker image based on scratch\n\033[0m"
#	@export DOCKER_CONTENT_TRUST=1 && docker build --build-arg flags="-X main.Version=${VERSION} -X main.Build=${BUILD}" -f Dockerfile -t say-hello .
	@export DOCKER_CONTENT_TRUST=1 && docker build --build-arg flags=$(LDFLAGS) -f Dockerfile -t say-hello .

.PHONY: build-no-cache
build-no-cache:	## - Build the golang docker image based on scratch with no cache
	@printf "\033[32m\xE2\x9c\x93 Build the golang docker image based on scratch\n\033[0m"
	@export DOCKER_CONTENT_TRUST=1 && docker build --no-cache --build-arg flags=$(LDFLAGS) -f Dockerfile -t say-hello .

.PHONY: push-to-azure
push-to-azure:	## - Push docker image to azurecr.io container registry
	@az acr login --name blank
	@docker push blank/golang-docker-image:$(VERSION)
