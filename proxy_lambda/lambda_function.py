import json
import requests

import urllib.parse as parse

CONTENT_TYPES = {
    'urlencoded': 'application/x-www-form-urlencoded',
    'json': 'application/json',
}

ENCODERS = {
    'urlencoded': lambda x: parse.urlencode(x),
    'json': lambda x: json.dumps(x),
}

REQUESTS = {
    'GET': lambda x, y, z: requests.get(x, headers=y, params=z, allow_redirects=False),
    'POST': lambda x, y, z: requests.post(x, headers=y, data=z, allow_redirects=False),
    'PUT': lambda x, y, z: requests.put(x, headers=y, data=z, allow_redirects=False),
    'DELETE': lambda x, y, z: requests.delete(x, headers=y, params=z, allow_redirects=False),
}

BODY_METHODS = ['POST','PUT']

def _get_content_type(encoding: str) -> str:
    return CONTENT_TYPES[encoding]

def _encode_body(params: dict, encoding: str) -> str:
    return ENCODERS[encoding](params)

def _normalise_headers(headers: dict) -> dict:
    return {str(key).lower(): value for key, value in headers.items()}

def proxy(request: dict) -> dict:
    uri = request['uri']
    method = request['method']
    headers = _normalise_headers(request['headers'])
    params = request['parameters']
    encoding = request['encoding']

    headers['content-type'] = _get_content_type(encoding)

    if method in BODY_METHODS:
        params = _encode_body(params, encoding)

    result = REQUESTS[method](uri, headers, params)

    response = {
        'uri': uri,
        'responseCode': result.status_code,
        'body': result.text,
        'headers': dict(result.headers)
    }

    return response
    