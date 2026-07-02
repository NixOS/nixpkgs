{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "sharedmem";
  version = "0.3.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xlSmvuLi81yC5syLbCYvyr03j1uhGsnvcVMPjau44vc=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "sharedmem" ];

  meta = {
    homepage = "http://rainwoodman.github.io/sharedmem/";
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3;
  };
})
