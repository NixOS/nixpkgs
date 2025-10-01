{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.22.2.20250924";
  pyproject = true;

  src = fetchPypi {
    pname = "types_docutils";
    inherit version;
    hash = "sha256-oT+0EmdsFk7ex8Lyb+Uqt7C3yGgWjazEKY9qgGkpjz0=";
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
