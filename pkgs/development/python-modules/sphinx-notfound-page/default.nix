{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
  # documentation build dependencies
  sphinxHook,
  sphinx-prompt,
  sphinx-rtd-theme,
  sphinx-tabs,
  sphinx-autoapi,
  sphinxemoji,
  # runtime dependencies
  sphinx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sphinx-notfound-page";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-notfound-page";
    tag = version;
    hash = "sha256-KkdbK8diuQtZQk6FC9xDK/U7mfRBwwUmXp4YYuKueLQ=";
  };

  nativeBuildInputs = [
    flit-core
    sphinxHook
    sphinx-prompt
    sphinx-rtd-theme
    sphinx-tabs
    sphinx-autoapi
    sphinxemoji
  ];

  buildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "notfound" ];

  meta = with lib; {
    description = "Sphinx extension to create a custom 404 page with absolute URLs hardcoded";
    homepage = "https://github.com/readthedocs/sphinx-notfound-page";
    changelog = "https://github.com/readthedocs/sphinx-notfound-page/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
