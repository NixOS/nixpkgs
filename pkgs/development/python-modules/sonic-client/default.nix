{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sonic-client";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "sonic-client";
    inherit (finalAttrs) version;
    hash = "sha256-/jJMc1RnBIjthIR/amcn08tfs2dcubYTltz1cg5aymY=";
  };

  build-system = [
    setuptools
  ];

  # No tests shipped in the PyPI sdist
  doCheck = false;

  pythonImportsCheck = [ "sonic" ];

  meta = {
    description = "Python client for sonic search backend";
    homepage = "https://github.com/xmonader/python-sonic-client";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
