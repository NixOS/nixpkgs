{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.20250516";
  pyproject = true;

  src = fetchPypi {
    pname = "types_html5lib";
    inherit version;
    hash = "sha256-ZQQ6ZxjJf31SVnzAzfQe+/wzsfksbAxeGfYKfsaa5yA=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "html5lib-stubs" ];

  meta = with lib; {
    description = "Typing stubs for html5lib";
    homepage = "https://pypi.org/project/types-html5lib/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
