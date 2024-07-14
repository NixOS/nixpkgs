{
  buildPythonPackage,
  fetchPypi,
  lib,
  numpy,
}:

buildPythonPackage rec {

  pname = "sharedmem";
  version = "0.3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xlSmvuLi81yC5syLbCYvyr03j1uhGsnvcVMPjau44vc=";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = "http://rainwoodman.github.io/sharedmem/";
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3;
  };
}
