FROM python:3.7 as build

WORKDIR /build

COPY app /build/
RUN pip install -r /build/requirements-dev.txt

RUN  pwd;pycodestyle /build/
RUN pylint /build



FROM python:3.7.3-alpine3.10  as application
ARG COMMIT_SHA
ARG VERSION

WORKDIR /app
COPY app ./
RUN pip install -r /app/requirements.txt

#execute app as non root user
RUN adduser -D api
USER api


ENV FLASK_APP=/app/app.py  COMMIT_SHA=${COMMIT_SHA} VERSION=${VERSION}
EXPOSE 5000
CMD ["python", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "5000"]