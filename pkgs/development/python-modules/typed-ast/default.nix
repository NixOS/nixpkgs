{ buildPythonPackage, fetchPypi, isPy3k, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.0.4";
  name = "${pname}-${version}";
  src = fetchPypi{
    inherit pname version;
    sha256 = "73f09aac0119f6664a3f471a1ec1c9b719f572bc9212913cea96a78b22c2e96e";
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
