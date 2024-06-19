{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "scripttest";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "951cfc25219b0cd003493a565f2e621fd791beaae9f9a3bdd7024d8626419c38";
  };

  buildInputs = [ pytest ];

  # Tests are not included. See https://github.com/pypa/scripttest/issues/11
  doCheck = false;

  meta = with lib; {
    description = "A library for testing interactive command-line applications";
    homepage = "https://pypi.org/project/scripttest/";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
