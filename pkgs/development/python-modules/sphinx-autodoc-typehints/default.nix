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
  version = "3.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "sphinx-autodoc-typehints";
    tag = finalAttrs.version;
    hash = "sha256-TyG63QHuiquofeMkr078FsBVc9TAqPFfzWJ5L9sdqm0=";
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
