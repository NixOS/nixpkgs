{ lib
, buildPythonPackage
, fetchPypi
, pbr
, python_mimeparse
, extras
, unittest2
, traceback2
, testscenarios
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5827ec6cf8233e0f29f51025addd713ca010061204fdea77484a2934690a0559";
  };

  propagatedBuildInputs = [ pbr python_mimeparse extras unittest2 ];
  buildInputs = [ traceback2 ];

  # testscenarios has a circular dependency on testtools
  doCheck = false;
  checkInputs = [ testscenarios ];

  # testtools 2.0.0 and up has a circular run-time dependency on futures
  postPatch = ''
    substituteInPlace requirements.txt --replace "fixtures>=1.3.0" ""
  '';

  meta = {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = https://pypi.python.org/pypi/testtools;
    license = lib.licenses.mit;
  };
}
