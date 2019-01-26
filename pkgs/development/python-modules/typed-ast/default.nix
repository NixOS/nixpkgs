{ buildPythonPackage, fetchPypi, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.1.1";
  src = fetchPypi{
    inherit pname version;
    sha256 = "1iml3lcw50bz1fyw7s9sa4mqzbmqs5w43k6bsv5ix4vqa34mvckc";
  };
  # Only works with Python 3.3 and newer;
  disabled = pythonOlder "3.3";
  # No tests in archive
  doCheck = false;
  meta = {
    homepage = https://pypi.python.org/pypi/typed-ast;
    description = "a fork of Python 2 and 3 ast modules with type comment support";
    license = lib.licenses.asl20;
  };
}
