FROM python:3.7 as build

WORKDIR /build

COPY . /build/
# Install the dependencies needed for testing
RUN pip install -r /build/app/requirements-dev.txt

# Execute the test suite
RUN pytest --verbose
RUN pycodestyle /build/app
RUN pylint /build/app
RUN safety check

# Create a new stage containing only production packages and code.
FROM python:3.7.3-alpine3.10  as application
# These argument values will be passed in at build time.
ARG COMMIT_SHA
ARG VERSION

WORKDIR /app
COPY app ./
RUN pip install -r /app/requirements.txt

#execute app as non root user
RUN adduser -D api
USER api

# Set the variables that the app will use to respond. Single line reduces layers
ENV FLASK_APP=/app/app.py  COMMIT_SHA=${COMMIT_SHA} VERSION=${VERSION}
EXPOSE 5000
CMD ["python", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "5000"]