{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-s3transfer";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "types_s3transfer";
    inherit version;
    hash = "sha256-aridTXa8v21JRYKUmWO0ZyNH6Nqjl9l5DzaEtPz4c8Q=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "s3transfer-stubs" ];

  meta = with lib; {
    description = "Type annotations and code completion for s3transfer";
    homepage = "https://github.com/youtype/types-s3transfer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
