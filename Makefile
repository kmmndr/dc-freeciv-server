REGISTRY_PROJECT_URL ?= quay.io/kmmndr/freeciv-server
# BUILD_ID ?= commit_sha
BUILD_ID ?=$(shell test -d .git && git rev-parse --short HEAD)
# REF_ID = branch_name
REF_ID ?=$(shell test -d .git && git symbolic-ref --short HEAD)

default: help
include *.mk

ci-build: docker-pull docker-build
ci-push: docker-push
ci-push-release: docker-pull-final docker-push-release

.PHONY: start
start: docker-compose-pull docker-compose-start ##- Start

.PHONY: deploy
deploy: docker-compose-pull docker-compose-deploy ##- Deploy (start remotely)

.PHONY: stop
stop: docker-compose-stop ##- Stop

.PHONY: logs
logs: docker-compose-logs ##- Logs

.PHONY: console
console: environment
	@${load_env}; docker-compose exec freeciv runuser -u civ -- tmux attach

backup-freeciv: environment ##- Backup freeciv data folder
	@$(load_env); echo "*** Backuping freeciv data folder ***"
	@$(load_env); docker-compose exec -T freeciv sh -c "tar -C /srv/freeciv -czf - ." > freeciv-$$(date +%s).tgz

restore-freeciv: freeciv-data.tgz environment ##- Restore freeciv data folder
	@$(load_env); echo "*** Restoring freeciv data folder ***"
	@$(load_env); pv freeciv-data.tgz | docker-compose exec -T freeciv sh -c "tar -C /srv/freeciv -xzf - ."
