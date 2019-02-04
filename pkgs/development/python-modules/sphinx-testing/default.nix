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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "133hwlsp859qcdi6cb5v0yf5l3lpz59kk7ac5fnyrs6sn911nhia";
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