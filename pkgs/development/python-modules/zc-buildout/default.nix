{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pip,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zc-buildout";
  version = "5.0.0a2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buildout";
    repo = "buildout";
    tag = version;
    hash = "sha256-IQBGHMcBHCaZjpjVOOXfci/MP2xYCKaManFopbMysfg=";
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
