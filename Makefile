default: all

all: build up

# ==========
# interaction tasks
bash: up
	docker-compose exec app bash

python: up
	docker-compose exec app python

# ==========
# frontend tasks
frontend-install frontend-init frontend-ci frontend-prod frontend-dev frontend-unit frontend-e2e : up
	$(eval task_name=$(shell echo "$@" | perl -pe 's/frontend-//'))
	@echo "runnning task @ frontend: $(task_name)"
	docker-compose exec app sudo service dbus start
	docker-compose exec app bash -c "cd frontend && make $(task_name)"

frontend-restore: frontend-ci

# ==========
# backend tasks
backend-webapi backend-test-unit backend-log-access backend-hello backend-post backend-test-request: up
	$(eval task_name=$(shell echo "$@" | perl -pe 's/backend-//'))
	@echo "runnning task @ backend: $(task_name)"
	docker-compose exec app bash -c "cd backend && make $(task_name)"

# switch mode
cpu gpu:
	@rm -f docker-compose.yml
	@ln -s docker/docker-compose.$@.yml docker-compose.yml

# run tasks
mlflow-run: up
	docker-compose exec app mlflow run --no-conda .

# ==========
# visualization tasks
mlflow-ui: up
	docker-compose exec app mlflow ui --host=0.0.0.0

mlflow-server: up
    docker-compose exec app mlflow server --host=0.0.0.0 \
		--backend-store-uri sqlite:///result/mlflow.db \
		--default-artifact-root=mlruns

tensorboard: up
	$(eval logdir:=$(shell ls -trd result/* | tail -n 1))
	echo $(logdir)
	docker-compose exec app tensorboard --host=0.0.0.0 --logdir=$(logdir)

# ==========
# docker-compose aliases
up:
	docker-compose up -d app

active:
	docker-compose up

ps images down:
	docker-compose $@

im:images

build:
	docker-compose build --no-cache

reup: down up

clean: clean-logs clean-container

clean-logs:
	rm -rf log/*.log

clean-container:
	docker-compose down --rmi all
	sudo rm -rf app/__pycache__
