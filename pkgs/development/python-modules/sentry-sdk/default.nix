{ stdenv, buildPythonPackage, fetchPypi, isPy3k, urllib3, certifi, django, flask, tornado, bottle, rq, falcon, celery, pyramid, sanic, aiohttp }:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f137cfb8bf709f69fa4634a7debd13284a3a590c374846285875be41d1fe87a8";
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
