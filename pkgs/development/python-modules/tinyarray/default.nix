{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tinyarray";
  version = "1.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7NNCj9iki2H8XwpBPt4D4n2zod1T/NSeJKNtEaiimro=";
  };

  build-system = [
    numpy
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tinyarray" ];

  meta = {
    description = "Arrays of numbers for Python, optimized for small sizes";
    homepage = "https://gitlab.kwant-project.org/kwant/tinyarray";
    changelog = "https://gitlab.kwant-project.org/kwant/tinyarray/-/tags/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
