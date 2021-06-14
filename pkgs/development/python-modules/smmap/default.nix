{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "4.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
