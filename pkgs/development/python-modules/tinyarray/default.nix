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
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7NNCj9iki2H8XwpBPt4D4n2zod1T/NSeJKNtEaiimro=";
  };

  nativeBuildInputs = [
    numpy
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Arrays of numbers for Python, optimized for small sizes";
    homepage = "https://gitlab.kwant-project.org/kwant/tinyarray";
    changelog = "https://gitlab.kwant-project.org/kwant/tinyarray/-/tags/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ urandom ];
  };
}
