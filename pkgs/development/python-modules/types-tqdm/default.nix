{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-requests,
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.67.0.20250404";
  pyproject = true;

  src = fetchPypi {
    pname = "types_tqdm";
    inherit version;
    hash = "sha256-6Zl8ZV/7ujq3j0QYtVEcBaVOdoJNBz0hIWbcc6pWx2g=";
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
