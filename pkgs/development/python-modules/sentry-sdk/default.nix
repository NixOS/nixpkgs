{ stdenv, buildPythonPackage, fetchPypi, urllib3, certifi, django, flask, tornado, sanic, aiohttp, bottle, rq, falcon, pyramid, celery }:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff14935cc3053de0650128f124c36f34a4be120b8cc522c149f5cba342c1fd05";
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
