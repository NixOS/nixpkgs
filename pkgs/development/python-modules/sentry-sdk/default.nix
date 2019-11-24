{ stdenv, buildPythonPackage, fetchPypi, isPy3k, urllib3, certifi, django, flask, tornado, bottle, rq, falcon, celery, pyramid, sanic, aiohttp }:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff1fa7fb85703ae9414c8b427ee73f8363232767c9cd19158f08f6e4f0b58fc7";
  };

  checkInputs = [ django flask tornado bottle rq falcon ]
  ++ stdenv.lib.optionals isPy3k [ celery pyramid sanic aiohttp ];

  propagatedBuildInputs = [ urllib3 certifi ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/getsentry/sentry-python";
    description = "New Python SDK for Sentry.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
  };
}
