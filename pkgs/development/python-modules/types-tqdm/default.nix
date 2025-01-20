{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.67.0.20241221";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5WBGYxBWkiOFq+ia6xivVhH0cerdeRigrX802EzUyMw=";
  };

  build-system = [ setuptools ];

  # This package does not have tests.
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for tqdm";
    homepage = "https://pypi.org/project/types-tqdm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
