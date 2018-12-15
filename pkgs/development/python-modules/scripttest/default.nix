{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  version = "1.3";
  pname = "scripttest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "951cfc25219b0cd003493a565f2e621fd791beaae9f9a3bdd7024d8626419c38";
  };

  buildInputs = [ pytest ];

  # Tests are not included. See https://github.com/pypa/scripttest/issues/11
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library for testing interactive command-line applications";
    homepage = https://pypi.python.org/pypi/ScriptTest/;
    license = licenses.mit;
  };

}
