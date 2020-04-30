# ANZ Tech Test 2.

I've elected to use Python/Flask to create basic HTTP API that, when queried on /version, 
returns a json response with  the application version, the commit hash of the build and
a description string which I've hardcoded.

## CI-CD

Github Actions will run a build & test on any push to a branch, giving immediate feedback about the 
proposed changes. 

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


## Versioning

Version releases are created when the master branch is tagged with a version number. Tags will trigger
Github Actions to execute the Publish workflow which will build the image with the appropriate version 
and hash identifier. The image is tagged latest and pushed to the Github docker registry.

Use `git tag` to create a version:

`git tag Version0.1.0 && git push --tags`


## Risks and Steps to Productionise 

- docker build would be a seperately maintained base image
- testing improvements
- We are assuming the appropriate variables are available to the app. 
- for imrpoved local testing I'd like to use a volume mount to mount the files to the docker container