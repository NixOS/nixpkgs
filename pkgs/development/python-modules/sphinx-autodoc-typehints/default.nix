{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  sphinx,
  pytestCheckHook,
}:

let
  pname = "sphinx-autodoc-typehints";
  version = "3.5.2";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_autodoc_typehints";
    inherit version;
    hash = "sha256-X81KPreqiUJMHi4yvtymbtw4NnVpyRaagPSz6TQXH9s=";
  };

  postPatch = ''
    # https://github.com/tox-dev/sphinx-autodoc-typehints/issues/586
    substituteInPlace src/sphinx_autodoc_typehints/__init__.py \
      --replace-fail "sphinx.ext.autodoc.mock" "sphinx.ext.autodoc._dynamic._mock"
  '';

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

  meta = {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
