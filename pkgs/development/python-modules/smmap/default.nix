{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "0.9.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0qlx25f6n2n9ff37w9gg62f217fzj16xlbh0pkz0lpxxjys64aqf";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = https://github.com/gitpython-developers/smmap;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
