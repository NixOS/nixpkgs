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
    sha256 = "2a421b42b2dae8ecad2b4c9d3953f9970e5a9c07bb2c66626338157435e5708c";
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