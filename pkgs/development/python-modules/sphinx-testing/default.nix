{ lib
, buildPythonPackage
, fetchPypi
, mock
, sphinx
, six
, python
}:

buildPythonPackage rec {
  pname = "sphinx-testing";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef661775b5722d7b00f67fc229104317d35637a4fb4434bf2c005afdf1da4d09";
  };

  checkInputs = [ mock ];
  propagatedBuildInputs = [ sphinx six ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  # Test failures https://github.com/sphinx-doc/sphinx-testing/issues/5
  doCheck = false;

  meta = {
    homepage = https://github.com/sphinx-doc/sphinx-testing;
    license = lib.licenses.bsd2;
    description = "Testing utility classes and functions for Sphinx extensions";
  };
}