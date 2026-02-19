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

buildPythonPackage rec {
  pname = "sphinx-jupyterbook-latex";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-jupyterbook-latex";
    tag = "v${version}";
    hash = "sha256-ZTR+s6a/++xXrLMtfFRmSmAeMWa/1de12ukxfsx85g4=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    packaging
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_jupyterbook_latex" ];

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

  meta = {
    description = "Latex specific features for jupyter book";
    homepage = "https://github.com/executablebooks/sphinx-jupyterbook-latex";
    changelog = "https://github.com/executablebooks/sphinx-jupyterbook-latex/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
