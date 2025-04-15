{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-requests,
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.67.0.20250401";
  pyproject = true;

  src = fetchPypi {
    pname = "types_tqdm";
    inherit version;
    hash = "sha256-dz+Pha3X5f/ogMjM65T1ms9T5ZI9oCTJF1fWo57puD8=";
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
}
