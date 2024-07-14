{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "yahooweather";
  version = "0.10";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6s6GYZTMJIMALhB5CoJGC7Z14ZfdMhFBqXj/O5+tXS8=";
  };

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Provide an interface to the Yahoo! Weather RSS feed";
    homepage = "https://github.com/pvizeli/yahooweather";
    license = licenses.bsd2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
