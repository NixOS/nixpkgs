{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "3.0.5";
  src = fetchPypi {
    inherit pname version;
    sha256 = "84c2751ef3072d4f6b2785ec7ee40244c6f45eb934d9e543e2c51f1bd3d54c50";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
