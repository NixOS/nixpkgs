{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.66.0.20240417";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ftzp71IuqNQOT1uNhN2KEWbu/BPO7np+FYvw8aFCGjE=";
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
