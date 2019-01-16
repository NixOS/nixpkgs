{ buildPythonPackage, fetchPypi, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.2.0";
  src = fetchPypi{
    inherit pname version;
    sha256 = "05gxwj18xja90lly53xkg4dpw96wnv9512wxmnvai061lhwn6wml";
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
