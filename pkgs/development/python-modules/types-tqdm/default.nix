{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-requests,
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.67.0.20250319";
  pyproject = true;

  src = fetchPypi {
    pname = "types_tqdm";
    inherit version;
    hash = "sha256-rpR6ZL2Nfte30rc2nfBfkYH4R+woKP3Iot6wu4cBrao=";
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
