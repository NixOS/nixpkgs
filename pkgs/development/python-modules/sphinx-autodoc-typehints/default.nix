{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pythonOlder,
  sphinx,
  pytestCheckHook,
}:

let
  pname = "sphinx-autodoc-typehints";
  version = "3.0.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "sphinx-autodoc-typehints";
    tag = version;
    hash = "sha256-v7gXUnSfp2TDljgG5z5PmY0Bewv9R8ZEzVH6epP/LBk=";
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
