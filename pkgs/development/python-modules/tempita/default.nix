{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "Tempita";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cacecf0baa674d356641f1d406b8bff1d756d739c46b869a54de515d08e6fc9c";
  };

  checkInputs = [ nose ];

  # No tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    homepage = http://pythonpaste.org/tempita/;
    description = "A very small text templating language";
    license = licenses.mit;
  };
}
