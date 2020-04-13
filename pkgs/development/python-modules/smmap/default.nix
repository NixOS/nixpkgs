{ lib, fetchPypi, buildPythonPackage, nosexcover }:

buildPythonPackage rec {
  pname = "smmap";
  version = "3.0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0ijlnv60y8f41py1wnn5n1a1i81cxd9dfpdhr0k3cgkrcbz8850p";
  };

  checkInputs = [ nosexcover ];

  meta = {
    description = "A pure python implementation of a sliding window memory map manager";
    homepage = "https://github.com/gitpython-developers/smmap";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
