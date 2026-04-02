{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  sphinx,

  # optional-dependencies
  furo,
  pydata-sphinx-theme,
  sphinx-rtd-theme,
  sphinx-book-theme,

  # tests
  defusedxml,
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-design";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-design";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NlAAIw8X2gW2ejeSHcFrxj7Jl6OgnpZIXPK16yzxxRQ=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  optional-dependencies = {
    theme-furo = [ furo ];
    theme-pydata = [ pydata-sphinx-theme ];
    theme-rtd = [ sphinx-rtd-theme ];
    theme-sbt = [ sphinx-book-theme ];
    # TODO: theme-im = [ sphinx-immaterial ];
  };

  pythonRelaxDeps = [ "sphinx" ];

  nativeCheckInputs = [
    defusedxml
    pytest-regressions
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = {
    description = "Sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
    changelog = "https://github.com/executablebooks/sphinx-design/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
