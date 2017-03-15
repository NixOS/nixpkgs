{ buildPythonPackage, fetchPypi, isPy3k, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.0.2";
  name = "${pname}-${version}";
  src = fetchPypi{
    inherit pname version;
    sha256 = "13e02b10479ddff07eb546f9638743702ab9b175bfa3cdf2482688df91b5766d";
  };
  # Only works with Python 3.3 and newer;
  disabled = pythonOlder "3.3";
  # No tests in archive
  doCheck = false;
  meta = {
    homepage = "https://pypi.python.org/pypi/typed-ast";
    description = "a fork of Python 2 and 3 ast modules with type comment support";
    license = lib.licenses.asl20;
  };
}
