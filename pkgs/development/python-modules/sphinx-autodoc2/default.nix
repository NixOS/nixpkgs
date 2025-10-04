{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  flit-core,

  astroid,
  typing-extensions,
  typer,

  pytestCheckHook,
  pytest-regressions,
  sphinx,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "sphinx-autodoc2";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sphinx-extensions2";
    repo = "sphinx-autodoc2";
    tag = "v${version}";
    hash = "sha256-Wu079THK1mHVilD2Fx9dIzuIOOYOXpo/EMxVczNutCI=";
  };

  build-system = [ flit-core ];

  dependencies = [
    astroid
    typing-extensions

    # cli deps
    typer
  ]
  ++ typer.optional-dependencies.standard;

  preCheck = ''
    # make sphinx_path an alias of pathlib.Path, since sphinx_path was removed in Sphinx v7.2.0
    substituteInPlace tests/test_render.py --replace-fail \
        'from sphinx.testing.util import path as sphinx_path' \
        'sphinx_path = Path'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-regressions
    sphinx
    defusedxml
  ];

  disabledTests = [
    # some generated files differ in newer versions of Sphinx
    "test_sphinx_build_directives"
  ];

  pythonImportsCheck = [ "autodoc2" ];

  meta = {
    changelog = "https://github.com/sphinx-extensions2/sphinx-autodoc2/releases/tag/v${version}";
    homepage = "https://github.com/sphinx-extensions2/sphinx-autodoc2";
    description = "Sphinx extension that automatically generates API documentation for your Python packages";
    license = lib.licenses.mit;
    mainProgram = "autodoc2";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
