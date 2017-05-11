{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pythonOlder }:

buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.0.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qlq60jb191xdr66gd7axjidchbbwasd7hgym27i5abyd5wl2637";
  };

  # Only works with Python 3.3 and newer;
  disabled = pythonOlder "3.3";

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/typed-ast";
    description = "a fork of Python 2 and 3 ast modules with type comment support";
    license = licenses.asl20;
  };
}
