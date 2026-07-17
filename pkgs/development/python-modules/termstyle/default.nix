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
    sha256 = "ef74b83698ea014112040cf32b1a093c1ab3d91c4dd18ecc03ec178fd99c9f9f";
  };

  # Only manual tests
  doCheck = false;

  meta = {
    description = "Console colouring for python";
    homepage = "https://pypi.org/project/python-termstyle/";
    license = lib.licenses.bsdOriginal;
  };
}
