{ buildPythonPackage, fetchPypi, isPy3k, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.0.3";
  name = "${pname}-${version}";
  src = fetchPypi{
    inherit pname version;
    sha256 = "67184179697ea9128fa8fec1d3b4e26b41d6a2eceab4674c6e3da4b024309862";
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
