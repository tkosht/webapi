
# ==========
# backend tasks
webapi:
	uvicorn \
        --host=0.0.0.0 \
        --log-config=conf/logging.ini \
        --app-dir=. \
        webapi:app

test-unit: 
	python -m pytest test

log-access:
	tail -0f log/access.log

hello:
	@sh bin/request_hello.sh

post:
	@sh bin/request_post.sh

test-request:
	@sh bin/test_request.sh
