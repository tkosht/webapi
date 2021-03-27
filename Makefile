default: all

all: build up

# ==========
# interaction tasks
bash: up
	docker-compose exec app bash

python: up
	docker-compose exec app python

frontend-install frontend-init frontend-ci frontend-prod frontend-dev frontend-unit frontend-e2e : up
	$(eval task=$(shell echo "$@" | perl -pe 's/frontend-//'))
	@echo "runnning task: $(task)"
	docker-compose exec app sudo service dbus start
	docker-compose exec app bash -c "cd frontend && make $(task)"

frontend-restore: frontend-ci

# ==========
# backend tasks
backend-webapi: up
	docker-compose exec app uvicorn \
        --host=0.0.0.0 \
        --log-config=backend/conf/logging.ini \
        --app-dir=. \
        backend.webapi:app

backend-test-unit: up
	docker-compose exec app \
        bash -c "cd backend && python -m pytest test"

backend-log-access: up
	tail -0f log/access.log

backend-hello:
	@sh bin/request_hello.sh

backend-post:
	@docker-compose exec app sh bin/request_post.sh

backend-test-requests:
	@docker-compose exec app sh bin/test_request.sh

# switch mode
gpu:
	@rm -f docker-compose.yml
	@ln -s docker/docker-compose.gpu.yml docker-compose.yml

cpu:
	@rm -f docker-compose.yml
	@ln -s docker/docker-compose.cpu.yml docker-compose.yml

# run tasks
mlflow-run: up
	docker-compose exec app mlflow run --no-conda .

debug: up
	docker-compose exec app pudb3 encoder.py

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
