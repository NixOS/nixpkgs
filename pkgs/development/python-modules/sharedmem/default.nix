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
    sha256 = "c654a6bee2e2f35c82e6cc8b6c262fcabd378f5ba11ac9ef71530f8dabb8e2f7";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = "http://rainwoodman.github.io/sharedmem/";
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3;
  };
}
