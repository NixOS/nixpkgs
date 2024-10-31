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
    sha256 = "0bsxmngkpzvqm50i2cnxjzhpbdhb8s10ly8h5q08696cjihqdkpa";
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
