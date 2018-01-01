{ lib
, buildPythonPackage
, fetchPypi
, pbr
, python_mimeparse
, extras
, lxml
, unittest2
, traceback2
, isPy3k
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "1.8.1";
  name = "${pname}-${version}";

  # Python 2 only judging from SyntaxError
#   disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "155ed29086e48156519e15f7801b702c15ba34d8700d80ba606101f448a3839f";
  };

  propagatedBuildInputs = [ pbr python_mimeparse extras lxml unittest2 ];
  buildInputs = [ traceback2 ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = http://pypi.python.org/pypi/testtools;
    license = lib.licenses.mit;
  };
}