{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# runtime
, certifi
, urllib3

# optionals
, aiohttp
, apache-beam
, blinker
, botocore
, bottle
, celery
, chalice
, django
, falcon
, flask
, flask_login
, httpx
, pure-eval
, pyramid
, pyspark
, rq
, sanic
, sqlalchemy
, tornado
, trytond
, werkzeug

# tests
, asttokens
, executing
, gevent
, jsonschema
, mock
, pyrsistent
, pytest-forked
, pytest-localserver
, pytest-watch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    rev = version;
    hash = "sha256-PtGQJUZ6/u2exmg6P5VV2RoBKyuV3G2YuAWgA06oQKo=";
  };

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    beam = [
      apache-beam
    ];
    bottle = [
      bottle
    ];
    celery = [
      celery
    ];
    chalice = [
      chalice
    ];
    django = [
      django
    ];
    falcon = [
      falcon
    ];
    flask = [
      flask
      blinker
    ];
    httpx = [
      httpx
    ];
    pyspark = [
      pyspark
    ];
    pure_eval = [
      asttokens
      executing
      pure-eval
    ];
    quart = [
      # quart missing
      blinker
    ];
    rq = [
      rq
    ];
    sanic = [
      sanic
    ];
    sqlalchemy = [
      sqlalchemy
    ];
    tornado = [
      tornado
    ];
  };

  checkInputs = [
    asttokens
    executing
    gevent
    jsonschema
    mock
    pure-eval
    pyrsistent
    pytest-forked
    pytest-localserver
    pytest-watch
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # Issue with the asseration
    "test_auto_enabling_integrations_catches_import_error"
  ];

  disabledTestPaths = [
    # Varius integration tests fail every once in a while when we
    # upgrade depencies, so don't bother testing them.
    "tests/integrations/"
  ] ++ lib.optionals (stdenv.buildPlatform != "x86_64-linux") [
    # test crashes on aarch64
    "tests/test_transport.py"
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
