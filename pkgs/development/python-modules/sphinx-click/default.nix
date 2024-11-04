{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  docutils,
  pbr,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-click";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "sphinx-click";
    rev = version;
    hash = "sha256-RL/e6eN9/8Baqq6Q0rU/b1ZJWt0LAeLzmfyOgDPbvnw=";
  };

  env.PBR_VERSION = version;

  build-system = [
    setuptools
    pbr
  ];

  propagatedBuildInputs = [
    click
    docutils
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_click" ];

  meta = {
    description = "A Sphinx plugin to automatically document click-based applications";
    homepage = "https://github.com/click-contrib/sphinx-click";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
