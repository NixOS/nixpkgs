{ aiohttp
, bottle
, buildPythonPackage
, celery
, certifi
, django
, falcon
, fetchPypi
, flask
, iana-etc
, isPy3k
, libredirect
, pyramid
, rq
, sanic
, sqlalchemy
, stdenv
, tornado
, urllib3
, trytond
, werkzeug
, executing
, pure-eval
, asttokens
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d91a0059d2d8bb980bec169578035c2f2d4b93cd8a4fb5b85c81904d33e221a";
  };

  checkInputs = [ django flask tornado bottle rq falcon sqlalchemy werkzeug trytond
    executing pure-eval asttokens ]
  ++ stdenv.lib.optionals isPy3k [ celery pyramid sanic aiohttp ];

  propagatedBuildInputs = [ urllib3 certifi ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/getsentry/sentry-python";
    description = "New Python SDK for Sentry.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
  };

  # The Sentry tests need access to `/etc/protocols` (the tests call
  # `socket.getprotobyname('tcp')`, which reads from this file). Normally
  # this path isn't available in the sandbox. Therefore, use libredirect
  # to make on eavailable from `iana-etc`. This is a test-only operation.
  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";
}
