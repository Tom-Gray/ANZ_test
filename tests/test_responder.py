from .test_fixpathing import app
from app import app

#from app import responder
import os

import pytest


@pytest.fixture
def client():
    """Set up test client."""
    os.environ['APP_VERSION'] = "1.0"
    os.environ['COMMIT_SHA'] = "aaaa"
    app.APP.config['TESTING'] = True
    client = app.APP.test_client()
    yield client


def test_empty_db(client):
    """Test the status end point.."""

    rv = client.get('/version')
    assert b'"version": "1.0"' in rv.data
    assert b'"lastcommitsha": "aaaa"' in rv.data
    assert b'"description" : "pre-interview technical test"' in rv.data
