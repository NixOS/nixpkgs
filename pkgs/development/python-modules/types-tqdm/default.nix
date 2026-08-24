{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-tqdm";
  version = "4.70.0.20260805";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_tqdm";
    inherit (finalAttrs) version;
    hash = "sha256-Vp79D9iypGDm5lSGNOwlPBNi7YkH+LDarPCgfqsgSiY=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-requests ];

  # This package does not have tests.
  doCheck = false;

  meta = {
    description = "Typing stubs for tqdm";
    homepage = "https://pypi.org/project/types-tqdm/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
