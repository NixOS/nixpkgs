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

buildPythonPackage {
  pname = "sphinx-tabs";
  version = "3.4.7-unstable-2026-01-24";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-tabs";
    rev = "d613cb7b6bff083227e35e9b3a4c56b24f6c6ad4";
    hash = "sha256-aYlc9bs37Mu4Beuggx0dgVdoRa+X65oDNnYg3Wa4dgc=";
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
}
