from test_fixpathing import app

import os
import pytest


@pytest.fixture
def client():
    """Set up test client."""
    os.environ['VERSION'] = "1.0"
    os.environ['COMMIT_SHA'] = "aaaa"
    app.APP.config['TESTING'] = True
    client = app.APP.test_client()
    yield client


def test_response(client):
    """Test the status end point.."""

    rv = client.get('/version')
    assert b'"version":"1.0"' in rv.data
    assert b'"lastcommitsha":"aaaa"' in rv.data
    assert b'"description":"ANZ Technical Test."' in rv.data
