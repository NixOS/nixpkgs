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
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.14.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e5e947d0f7a969314aa23669a94a9712be5a688ff069ff7b9fc36c66adc160c";
  };

  checkInputs = [ django flask tornado bottle rq falcon sqlalchemy werkzeug trytond ]
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
