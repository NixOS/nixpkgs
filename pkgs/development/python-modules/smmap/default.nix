{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "5.0.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936";
  };

  nativeCheckInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
