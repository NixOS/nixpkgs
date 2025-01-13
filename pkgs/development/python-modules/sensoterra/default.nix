{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sensoterra";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WfjTOns5OPU8+ufDeFdDGjURhBWUFfw/qRSHQazBL04=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "sensoterra" ];

  meta = {
    description = "Query Sensoterra probes using the Customer API";
    homepage = "https://gitlab.com/sensoterra/public/python";
    changelog = "https://gitlab.com/sensoterra/public/python/-/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
