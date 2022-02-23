{ lib
, stdenv
, aiohttp
, asttokens
, blinker
, botocore
, bottle
, buildPythonPackage
, celery
, certifi
, chalice
, django
, executing
, fakeredis
, falcon
, fetchFromGitHub
, flask_login
, gevent
, httpx
, iana-etc
, isPy3k
, jsonschema
, libredirect
, pure-eval
, pyramid
, pyspark
, pytest-django
, pytest-forked
, pytest-localserver
, pytestCheckHook
, rq
, sanic
, sanic-testing
, sqlalchemy
, tornado
, trytond
, urllib3
, werkzeug
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "1.5.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    rev = version;
    sha256 = "sha256-PxoxOeFdmmfpXBnGs9D5aKP6vlGKx9nPO3ngYuTa+Rs=";
  };

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  checkInputs = [
    asttokens
    blinker
    botocore
    bottle
    chalice
    django
    executing
    fakeredis
    falcon
    flask_login
    gevent
    jsonschema
    pure-eval
    pytest-django
    pytest-forked
    pytest-localserver
    pytestCheckHook
    rq
    sqlalchemy
    tornado
    trytond
    werkzeug
  ] ++ lib.optionals isPy3k [
    aiohttp
    celery
    httpx
    pyramid
    pyspark
    sanic
    sanic-testing
  ];

  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # Issue with the asseration
    "test_auto_enabling_integrations_catches_import_error"
    # Output mismatch in sqlalchemy test
    "test_too_large_event_truncated"
    # Failing falcon tests
    "test_has_context"
    "uri_template-"
    "path-"
    "test_falcon_large_json_request"
    "test_falcon_empty_json_request"
    "test_falcon_raw_data_request"
    # Failing spark tests
    "test_set_app_properties"
    "test_start_sentry_listener"
    # Failing threading test
    "test_circular_references"
    # Failing wsgi tests
    "test_session_mode_defaults_to_request_mode_in_wsgi_handler"
    "test_auto_session_tracking_with_aggregates"
    # Network requests to public web
    "test_crumb_capture"
  ];

  disabledTestPaths = [
    # Some tests are failing (network access, assertion errors)
    "tests/integrations/aiohttp/"
    "tests/integrations/gcp/"
    "tests/integrations/httpx/"
    "tests/integrations/stdlib/test_httplib.py"
    # Tests are blocking
    "tests/integrations/celery/"
    # pytest-chalice is not available in nixpkgs yet
    "tests/integrations/chalice/"
    # broken since rq-1.10.1: https://github.com/getsentry/sentry-python/issues/1274
    "tests/integrations/rq/"
  ];

  pythonImportsCheck = [
    "sentry_sdk"
  ];

  meta = with lib; {
    description = "Python SDK for Sentry.io";
    homepage = "https://github.com/getsentry/sentry-python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab gebner ];
  };
}
