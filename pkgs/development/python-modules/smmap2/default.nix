{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap2";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc216005e529d57007ace27048eb336dcecb7fc413cfb3b2f402bb25972b69c6";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = https://pypi.org/project/smmap2;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
