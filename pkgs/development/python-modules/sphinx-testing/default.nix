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
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cbgkp770d7k85nmqkz50wk09xjwcmqw7sb2z17086n7vc1hy2rf";
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