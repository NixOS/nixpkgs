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
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d30f93007620e137b33edf19f52a7225eab853546b7e588ef09d1342e821e94";
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