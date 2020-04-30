

docker-build:
	docker build --build-arg VERSION=dev --build-arg COMMIT_SHA=12345  -t app .    

run:
	docker run -p5000:5000 app:latest    