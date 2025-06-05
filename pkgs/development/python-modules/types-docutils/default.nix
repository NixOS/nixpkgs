{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.21.0.20250526";
  pyproject = true;

  src = fetchPypi {
    pname = "types_docutils";
    inherit version;
    hash = "sha256-bHujh3FjFd8NhqeWuuydWnGCXtJ0bLd2MZOq+7cKyGw=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "docutils-stubs" ];

  meta = with lib; {
    description = "Typing stubs for docutils";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
