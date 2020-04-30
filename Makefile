
APP = anz_test
REPO = docker.pkg.github.com/tom-gray/$(APP)
COMMIT_SHA = $(shell git rev-parse --short HEAD)
VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)



docker-build:
	docker build \
	  --build-arg VERSION=$(VERSION) \
	  --build-arg COMMIT_SHA=$(COMMIT_SHA)\
	  -t $(APP):$(VERSION) .    

run:
	docker run -detach -p5000:5000 $(APP)  

# only execute the 'build' stage of the docker image
test:
	docker build \
	  --build-arg VERSION=$(VERSION) \
	  --build-arg COMMIT_SHA=$(COMMIT_SHA) \
	  --target build \
	  -t $(APP) . 

publish:
	docker push $(APP):$(VERSION) $(REPO)/$(APP):$(VERSION)
	docker tag $(APP):$(VERSION) $(APP):latest
	docker push $(APP):latest $(REPO)/$(APP):latest

