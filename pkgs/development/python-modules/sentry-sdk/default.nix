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
, pythonOlder
, rq
, sanic
, sanic-testing
, sqlalchemy
, tornado
, trytond
, urllib3
, werkzeug
, multidict
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "1.5.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    rev = version;
    hash = "sha256-8M0FWfvaGp74Fb+qJlhyiJPUVHN2ZdEleZf27d+bftE=";
  };

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  checkInputs = [
    aiohttp
    asttokens
    blinker
    botocore
    bottle
    celery
    chalice
    django
    executing
    fakeredis
    falcon
    flask_login
    gevent
    httpx
    jsonschema
    pure-eval
    pyramid
    pyspark
    pytest-django
    pytest-forked
    pytest-localserver
    pytestCheckHook
    rq
    sanic
    sanic-testing
    sqlalchemy
    tornado
    trytond
    werkzeug
    multidict
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
    # TypeError: cannot unpack non-iterable TestResponse object
    "test_rpc_error_page"
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
    # broken since pytest 7.0.1; AssertionError: previous item was not torn down properly
    "tests/utils/test_contextvars.py"
    # broken since Flask and Werkzeug update to 2.1.0 (different error messages)
    "tests/integrations/flask/test_flask.py"
    "tests/integrations/bottle/test_bottle.py"
    "tests/integrations/django/test_basic.py"
    "tests/integrations/pyramid/test_pyramid.py"
  ]
  # test crashes on aarch64
  ++ lib.optionals (stdenv.buildPlatform != "x86_64-linux") [
    "tests/test_transport.py"
    "tests/integrations/threading/test_threading.py"
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
