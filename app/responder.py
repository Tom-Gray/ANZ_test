
"""
This module file contains functions relating to the operation of this app
"""


def make_response(version, lastcommitsha):
    """
    Creates a reply and returns it
    """
    response = {
        "myapplication": [{
            "version": version,
            "lastcommitsha": lastcommitsha,
            "description": "ANZ Technical Test."
        }]
    }
    return response
