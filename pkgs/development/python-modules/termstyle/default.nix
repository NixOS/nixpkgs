{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "termstyle";
  version = "0.1.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-73S4NpjqAUESBAzzKxoJPBqz2RxN0Y7MA+wXj9mcn58=";
  };

  # Only manual tests
  doCheck = false;

  meta = with lib; {
    description = "Console colouring for python";
    homepage = "https://pypi.python.org/pypi/python-termstyle/0.1.10";
    license = licenses.bsdOriginal;
  };
}
