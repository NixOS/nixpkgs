{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-html5lib,
}:

buildPythonPackage rec {
  pname = "types-beautifulsoup4";
  version = "4.12.0.20250204";
  pyproject = true;

  src = fetchPypi {
    pname = "types_beautifulsoup4";
    inherit version;
    hash = "sha256-8IPY7cvQEnn4w5lbVs//LQHxu4lMO1AroRjTb7vElb8=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-html5lib ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "bs4-stubs" ];

  meta = with lib; {
    description = "Typing stubs for beautifulsoup4";
    homepage = "https://pypi.org/project/types-beautifulsoup4/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
