"""
Basic Python/Flash app to return data on /version
"""
import os
from flask import Flask, jsonify
from responder import make_response

APP = Flask(__name__)


@APP.route('/version')
def main():
    """
    Returns version details to the caller
    """
    return jsonify(make_response(
        version=os.environ['VERSION'],
        lastcommitsha=os.environ['COMMIT_SHA']
    ))


PORT = int(os.environ.get("PORT", 5000))
if __name__ == '__main__':
    APP.run(host='0.0.0.0', port=PORT)
