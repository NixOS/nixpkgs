{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-urllib3,
  urllib3,
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.32.4.20250809";
  pyproject = true;

  src = fetchPypi {
    pname = "types_requests";
    inherit version;
    hash = "sha256-2AYN4cjuWZMR9W/1gBD7SQL0YqFHCALPn27Se8RsTfM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    types-urllib3
    urllib3
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "requests-stubs" ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
