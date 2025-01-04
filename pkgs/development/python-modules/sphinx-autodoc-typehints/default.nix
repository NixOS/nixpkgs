{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pythonOlder,
  sphinx,
  pytestCheckHook,
}:

let
  pname = "sphinx-autodoc-typehints";
  version = "2.5.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sphinx_autodoc_typehints";
    inherit version;
    hash = "sha256-JZ4QJrIY1WPXJ0P0F/zCWQapYUiX/jf5G9jX1Y90jDs=";
  };

  pythonRelaxDeps = [ "sphinx" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires spobjinv, nbtyping
  doCheck = false;

  pythonImportsCheck = [ "sphinx_autodoc_typehints" ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
