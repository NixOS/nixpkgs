{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # documentation build dependencies
  sphinxHook,
  # runtime dependencies
  sphinx,
  pygments,
  docutils,
  # test dependencies
  pytest,
  beautifulsoup4,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-tabs";
  version = "3.5.0";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-tabs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OuGrrlCEkTxu3WueCPHHuEeMGXPf/lrETbTP/9uVWbU=";
  };

  nativeBuildInputs = [
    setuptools
    sphinxHook
  ];

  propagatedBuildInputs = [
    sphinx
    pygments
    docutils
  ];

  nativeCheckInputs = [
    pytest
    beautifulsoup4
  ];

  pythonImportsCheck = [ "sphinx_tabs" ];

  meta = {
    description = "Sphinx extension for creating tabbed content when building HTML";
    homepage = "https://github.com/executablebooks/sphinx-tabs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
})
