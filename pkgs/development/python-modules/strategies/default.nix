{
  lib,
  buildPythonPackage,
  fetchPypi,
  multipledispatch,
  toolz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "strategies";
  version = "0.2.3";

  __structuredAttrs = true;
  pyproject = true;

  # GitHub upstream do not have proper release tags
  src = fetchPypi {
    pname = "strategies";
    inherit (finalAttrs) version;
    hash = "sha256-SIxVpdf4h8UpDwMgnhFiL12k51SCbrEjusHMpHPzJAo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    multipledispatch
    toolz
  ];

  doCheck = false; # no tests in Pypi archive

  meta = {
    description = "Python library for control flow programming";
    homepage = "https://github.com/logpy/strategies";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ suhr ];
  };
})
