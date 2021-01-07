{ aiohttp
, blinker
, botocore
, bottle
, buildPythonPackage
, celery
, certifi
, chalice
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
  version = "0.19.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1052f0ed084e532f66cb3e4ba617960d820152aee8b93fc6c05bd53861768c1c";
  };

  checkInputs = [ blinker botocore chalice django flask tornado bottle rq falcon sqlalchemy werkzeug trytond
    executing pure-eval asttokens ]
  ++ stdenv.lib.optionals isPy3k [ celery pyramid sanic aiohttp ];

  propagatedBuildInputs = [ urllib3 certifi ];


  # The Sentry tests need access to `/etc/protocols` (the tests call
  # `socket.getprotobyname('tcp')`, which reads from this file). Normally
  # this path isn't available in the sandbox. Therefore, use libredirect
  # to make on eavailable from `iana-etc`. This is a test-only operation.
  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "sentry_sdk" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/getsentry/sentry-python";
    description = "New Python SDK for Sentry.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
  };
}
