{ stdenv, buildPythonPackage, fetchPypi, urllib3, certifi, django, flask, tornado, sanic, aiohttp, bottle, rq, falcon, pyramid, celery }:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5819df450d7b0696be69a0c6d70a09e4890a3844ee8ccb7a461794135bd5965";
  };

  checkInputs = [ django flask tornado sanic aiohttp bottle rq falcon pyramid celery ];

  propagatedBuildInputs = [ urllib3 certifi ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/getsentry/sentry-python";
    description = "New Python SDK for Sentry.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
  };
}
