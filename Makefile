.DEFAULT_GOAL := help

ENV_LIST = macos macos-sierra ubuntu ubuntu-desktop windows

list-env: ## List up supported envirnoments
	@printf "\033[36menvirnoment%-19s\033[0m $(ENV_LIST)\n"

init: 
ifndef ENV
	$(error `ENV` is not set)
endif
ifneq ($(findstring $(ENV),$(ENV_LIST)),)
	$(info Target OS is "$(ENV)", ready)
else
	$(error It is not supported OS "$(ENV)")
endif

check: 
	$(if $(shell if ./install/${env}.sh; then echo ok; fi), , $(error `./install/${env}.sh` failed))

install: init check ## Run installation: `make ENV={envirnoment} install;`
	./install/${env}.sh

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help install init check
