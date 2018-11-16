{ buildPythonPackage, fetchPypi, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.1.0";
  src = fetchPypi{
    inherit pname version;
    sha256 = "57fe287f0cdd9ceaf69e7b71a2e94a24b5d268b35df251a88fef5cc241bf73aa";
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
