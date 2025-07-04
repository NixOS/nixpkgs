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
  version = "2.32.4.20250611";
  pyproject = true;

  src = fetchPypi {
    pname = "types_requests";
    inherit version;
    hash = "sha256-dByHd+1kJYML9R5U1qviRfebTcuQGfFiK3c0Y5Rr+CY=";
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
