default: up

all: run

bash: up
	docker-compose exec app bash

python: up
	docker-compose exec app python

frontend-install: up
	docker-compose exec app sh bin/install_vue.sh

frontend-init: up
	docker-compose exec app sh bin/init_frontend.sh

frontend-restore: frontend-ci

frontend-ci: up
	docker-compose exec app sh bin/build_vue.sh ci

frontend-build: up
	docker-compose exec app sh bin/build_vue.sh

frontend-dev: up
	docker-compose exec app sh bin/build_vue.sh dev

webapi: up
	docker-compose exec app uvicorn \
        --host=0.0.0.0 \
        --log-config=backend/conf/logging.ini \
        --app-dir=. \
        backend.webapi:app

log-access: up
	tail -0f log/access.log

hello:
	@sh bin/request_hello.sh

post:
	@docker-compose exec app sh bin/request_post.sh

test-requests:
	@docker-compose exec app sh bin/test_request.sh

# switch mode
gpu:
	@rm -f Dockerfile docker-compose.yml
	@ln -s docker/docker-compose.gpu.yml docker-compose.yml

cpu:
	@rm -f Dockerfile docker-compose.yml
	@ln -s docker/docker-compose.cpu.yml docker-compose.yml

# run tasks
mlflow-run: up
	docker-compose exec app mlflow run --no-conda .

debug: up
	docker-compose exec app pudb3 encoder.py

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

# for docker-compose
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
