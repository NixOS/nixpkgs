{ lib
, fetchFromGitHub
, buildPythonPackage
, aiohttp
, bottle
, celery
, certifi
, django
, falcon
, flask
, iana-etc
, libredirect
, pytest
, pytest-localserver
, pytest-aiohttp
, pytest-forked
, pyramid
, rq
, sanic
, stdenv
, tornado
, urllib3
, sqlalchemy
, gevent
, fakeredis
, flask_login
, isPy3k
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    rev = version;
    sha256 = "1m1iffk3qxgmywqj6a9n8b8d2ai39zqdhf4zqr34q25s3l10wxpz";
  };

  checkInputs = [
    pytest
    pytest-localserver
    pytest-aiohttp
    pytest-forked
    django
    flask
    tornado
    bottle
    rq
    falcon
    sqlalchemy
    gevent
    fakeredis
    flask_login
  ] ++ stdenv.lib.optionals isPy3k [
    celery
    pyramid
    sanic
    aiohttp
  ];

  propagatedBuildInputs = [
    urllib3
    certifi
  ];

  # The Sentry tests need access to `/etc/protocols` (the tests call
  # `socket.getprotobyname('tcp')`, which reads from this file). Normally
  # this path isn't available in the sandbox. Therefore, use libredirect
  # to make on eavailable from `iana-etc`. This is a test-only operation.
  checkPhase = ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
    export LD_PRELOAD=${libredirect}/lib/libredirect.so

    # rm -rf tests/integrations
    pytest -k "not test_atexit and not test_filename" -x \
           --ignore=tests/test_transport.py \
           --ignore=tests/integrations/django/test_basic.py \
           --ignore=tests/integrations/excepthook/test_excepthook.py \
           --ignore=tests/integrations/requests/test_requests.py \
           --ignore=tests/integrations/sanic/test_sanic.py \
           --ignore=tests/integrations/stdlib/test_httplib.py \
           --ignore=tests/integrations/stdlib/test_subprocess.py \
           --ignore=tests/integrations/threading/test_threading.py \
           --ignore=tests/utils/test_contextvars.py

    unset NIX_REDIRECTS LD_PRELOAD
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/getsentry/sentry-python";
    description = "New Python SDK for Sentry.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
  };
}
