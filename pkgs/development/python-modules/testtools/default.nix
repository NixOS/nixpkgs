{ lib
, buildPythonPackage
, fetchPypi
, pbr
, python-mimeparse
, extras
, unittest2
, traceback2
, testscenarios
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57c13433d94f9ffde3be6534177d10fb0c1507cc499319128958ca91a65cb23f";
  };

  propagatedBuildInputs = [ pbr python-mimeparse extras unittest2 ];
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
    homepage = "https://pypi.python.org/pypi/testtools";
    license = lib.licenses.mit;
  };
}
