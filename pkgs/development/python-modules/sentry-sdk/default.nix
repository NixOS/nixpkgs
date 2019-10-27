{ stdenv, buildPythonPackage, fetchPypi, urllib3, certifi, django, flask, tornado, sanic, aiohttp, bottle, rq, falcon, pyramid, celery }:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f137cfb8bf709f69fa4634a7debd13284a3a590c374846285875be41d1fe87a8";
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
