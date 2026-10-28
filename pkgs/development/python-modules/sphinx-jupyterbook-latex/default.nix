{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  packaging,
  sphinx,
  click,
  myst-parser,
  pytest-regressions,
  pytestCheckHook,
  sphinx-external-toc,
  sphinxcontrib-bibtex,
  texsoup,
  defusedxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-jupyterbook-latex";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-jupyterbook-latex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZTR+s6a/++xXrLMtfFRmSmAeMWa/1de12ukxfsx85g4=";
  };

  patches = [
    # sphinx.testing.path.path was removed in Sphinx 8; use pathlib.Path.
    ./sphinx-8-testing-path.patch
  ];

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    packaging
    sphinx
  ];

  nativeCheckInputs = [
    click
    myst-parser
    pytest-regressions
    pytestCheckHook
    sphinx-external-toc
    sphinxcontrib-bibtex
    texsoup
    defusedxml
  ];

  disabledTests = [
    "test_jblatex_show_tocs"
    "test_build_no_ext"
    "test_build_with_ext"
  ];

  pythonImportsCheck = [ "sphinx_jupyterbook_latex" ];

  meta = {
    description = "Latex specific features for jupyter book";
    homepage = "https://github.com/executablebooks/sphinx-jupyterbook-latex";
    changelog = "https://github.com/executablebooks/sphinx-jupyterbook-latex/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
