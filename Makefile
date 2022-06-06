DOCKER_COMPOSE_CHECK := docker compose run --rm

# Linting
########################################################################

.PHONY: lint
lint: lint-plugin lint-shell

.PHONY: lint-plugin
lint-plugin:
	$(DOCKER_COMPOSE_CHECK) plugin-linter

.PHONY: lint-shell
lint-shell:
	./pants lint ::

# Formatting
########################################################################

.PHONY: format
format: format-shell

.PHONY: format-shell
format-shell:
	./pants fmt ::

# Testing
########################################################################

.PHONY: test
test: test-plugin test-shell

.PHONY: test-plugin
test-plugin:
	$(DOCKER_COMPOSE_CHECK) plugin-tester

.PHONY: test-shell
test-shell:
	./pants test ::

########################################################################

.PHONY: all
all: format lint test
