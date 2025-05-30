{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.21.0.20250516";
  pyproject = true;

  src = fetchPypi {
    pname = "types_docutils";
    inherit version;
    hash = "sha256-l15a3p7wsfRbawdfAXoPRw7k5TsMLdUMy/OgTZxTgW8=";
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
