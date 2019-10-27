{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap2";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29a9ffa0497e7f2be94ca0ed1ca1aa3cd4cf25a1f6b4f5f87f74b46ed91d609a";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = https://pypi.org/project/smmap2;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
