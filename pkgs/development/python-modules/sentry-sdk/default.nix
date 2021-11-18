{ lib
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
, falcon
, fetchPypi
, flask
, httpx
, iana-etc
, isPy3k
, libredirect
, pure-eval
, pyramid
, pyspark
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
  version = "1.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eJoRqHygJJGJbhIe/dZOj9kzJ7aejy99QvA+JWlkjog=";
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
    falcon
    flask
    pure-eval
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
  ];

  # The Sentry tests need access to `/etc/protocols` (the tests call
  # `socket.getprotobyname('tcp')`, which reads from this file). Normally
  # this path isn't available in the sandbox. Therefore, use libredirect
  # to make on eavailable from `iana-etc`. This is a test-only operation.
  preCheck = lib.optionalString doCheck ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  # no tests
  doCheck = true;

  pythonImportsCheck = [
    "sentry_sdk"
  ];

  meta = with lib; {
    homepage = "https://github.com/getsentry/sentry-python";
    description = "New Python SDK for Sentry.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
  };
}
