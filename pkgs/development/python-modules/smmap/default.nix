{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "3.0.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
