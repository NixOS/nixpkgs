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
<<<<<<< HEAD
  version = "3.5.2";
=======
  version = "3.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_autodoc_typehints";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-X81KPreqiUJMHi4yvtymbtw4NnVpyRaagPSz6TQXH9s=";
=======
    hash = "sha256-oknrcmSdBbS4fUKgykIln1UEmg/xVTk0FGP1nkslasU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
