{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pip,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zc-buildout";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buildout";
    repo = "buildout";
    tag = version;
    hash = "sha256-Z47j0RbQXP4DjJM+Fz0FXP2DuXwqluV64uCbioWtqW4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pip ];

  doCheck = false; # Missing package & BLOCKED on "zc.recipe.egg"

  pythonImportsCheck = [ "zc.buildout" ];

  pythonNamespaces = [ "zc" ];

  meta = {
    description = "Software build and configuration system";
    mainProgram = "buildout";
    downloadPage = "https://github.com/buildout/buildout";
    homepage = "https://www.buildout.org";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ gotcha ];
  };
}
