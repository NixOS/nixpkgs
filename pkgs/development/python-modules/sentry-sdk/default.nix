{ lib
, stdenv
, aiohttp
, apache-beam
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
, falcon
, fetchFromGitHub
, flask
, flask-login
, gevent
, httpx
, jsonschema
, mock
, pure-eval
, pyramid
, pyrsistent
, pyspark
, pytest-forked
, pytest-localserver
, pytest-watch
, pytestCheckHook
, pythonOlder
, rq
, sanic
, sqlalchemy
, tornado
, trytond
, urllib3
, werkzeug
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "1.32.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    rev = "refs/tags/${version}";
    hash = "sha256-chDgy3U29X/xk+aQok9uODcN0iAds1H39yXk98/3Yzc=";
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

  nativeCheckInputs = [
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
    changelog = "https://github.com/getsentry/sentry-python/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab gebner ];
  };
}
