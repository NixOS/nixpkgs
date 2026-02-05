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

buildPythonPackage rec {
  pname = "sphinx-tabs";
  version = "3.4.7";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-tabs";
    tag = "v${version}";
    hash = "sha256-bJXm3qMT1y7NqUA0iiEUA+USTWHxdV8tbEEiDrQKk1U=";
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
