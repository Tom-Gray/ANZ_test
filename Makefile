COMMIT_SHA = $(shell git rev-parse --short HEAD)
VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)

docker-build:
	docker build --build-arg VERSION=$(VERSION) --build-arg COMMIT_SHA=$(COMMIT_SHA)  -t app .    

run:
	docker run -detach -p5000:5000 app:latest    

