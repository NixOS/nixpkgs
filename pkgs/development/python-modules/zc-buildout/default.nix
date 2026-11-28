{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  packaging,
  pip,
  platformdirs,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "zc-buildout";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buildout";
    repo = "buildout";
    tag = version;
    hash = "sha256-qZ+FNBQih6DBWH9gZehIVb/0VWsQlDhqD0LEijInEf4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    pip
    platformdirs
    setuptools
    wheel
  ];

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
