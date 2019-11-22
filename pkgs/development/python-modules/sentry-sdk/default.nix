{ stdenv, buildPythonPackage, fetchPypi, isPy3k, urllib3, certifi, django, flask, tornado, bottle, rq, falcon, celery, pyramid, sanic, aiohttp }:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff14935cc3053de0650128f124c36f34a4be120b8cc522c149f5cba342c1fd05";
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
