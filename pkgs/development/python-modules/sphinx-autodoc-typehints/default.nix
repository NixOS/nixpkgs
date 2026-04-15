{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-autodoc-typehints";
  version = "3.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "sphinx-autodoc-typehints";
    tag = finalAttrs.version;
    hash = "sha256-RfeY9i7M+5SoZtJzdORm/ZyCZ+RLyERJFK7I9L1B7ws=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires spobjinv, nbtyping
  doCheck = false;

  pythonImportsCheck = [ "sphinx_autodoc_typehints" ];

  meta = {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${finalAttrs.version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
