{ buildPythonPackage, fetchPypi, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.3.1";
  src = fetchPypi{
    inherit pname version;
    sha256 = "606d8afa07eef77280c2bf84335e24390055b478392e1975f96286d99d0cb424";
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
