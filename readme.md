# ANZ Tech Test 2.

I've elected to use Python/Flask to create basic HTTP API that, when queried on /version, 
returns a json response with  the application version, the commit hash of the build and
a description string which I've hardcoded.

## CI-CD

Github Actions will run a build & test on any push to a branch, giving immediate feedback about the 
proposed changes. 
Tests are run in a Test stage of a Docker multistage build. Any test or linting failure will stop the 
container build.

A PR can be made to merge the branch to master. This PR cannot be approved unless the branch build is
successful. 

### Testing Performed

The pipeline runs the following tests during image build:
- pycodestyle
- pylint
- pytest
- dependency security scan (safety check)

Once the image build is complete and the image has been created, a CI step will launch the image and 
test the /version endpoint to ensure it responds. A non-200 response will fail the build. 


Developers can run `make test` from their workstation to run a local build and test operation.


## Versioning

Version releases are created when the master branch is tagged with a version number. Tags will trigger
Github Actions to execute the Publish workflow which will build the image with the appropriate version 
and hash identifier. The image is tagged latest and pushed to the Github docker registry.

The release pipeline expects the tags to be in this format: version0.0.0

Use `git tag` to create a version:

`git tag Version0.1.0 && git push --tags`

## Deploying

The app can be run using

`docker run -p5000:5000 -t docker.pkg.github.com/tom-gray/anz_test/anz_test:latest`



## Risks 
There are a handful of things I'd like to address before we take this app to production:


- Ideally I would like to make the base image a seperately built and maintained image that other images could build from.
- We're utilising a lot of public services. Code, docker images, packages and build-runners (agents) should all be brought in-house to improve security. 
- We are assuming the appropriate variables are available to the app. We should have some checks and decide how the app should behave if they dont exist or are not the expected format.
- Security tests are limited to Dependeny checks and PR revewiers. There's no automated code analysis currently which is something to consider. 
- Local testing could be improved by launching a container with a volume mount to the applicaiton directory. This way a developer would be able to run a test by running a container instead of having to build the entire container each time they want to run the test suite. We need to keep those devs happy and productive. We can't have them waiting for things.
- The app in it's current form has no state so it will be simple to scale out to protect againts failures and to provide additional capacity if traffic increases. A scheduler such as Kubernetes could handle this for us.
- While Flask is running in "Production" mode, it is not designed to recieve production-like requests. It would be necessary to spend some effort on introducing a WSGI such as Gunicorn to properly route traffic to and from the API. Employing a reverse proxy such as NGINX should also be considered.
- Trunk-based development may not be suitable as it encourages frequent production deployments. Business requirements may require us to change the git workflow, perhaps with a QA\Staging branch that can be tested and signed off on before being promoted to production. 
- Any deployment mechanism should include a rollback funcion. 
