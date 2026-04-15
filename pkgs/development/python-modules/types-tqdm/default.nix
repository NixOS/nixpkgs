{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-tqdm";
  version = "4.67.3.20260303";
  pyproject = true;

  src = fetchPypi {
    pname = "types_tqdm";
    inherit (finalAttrs) version;
    hash = "sha256-e/3bUGp1rttAMPq/TwXFY4yaO735ANVOxsgr6QNL+5Y=";
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
