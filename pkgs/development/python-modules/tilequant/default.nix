{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-dso,

  # dependencies
  click,
  ordered-set,
  pillow,
  sortedcollections,
}:

buildPythonPackage rec {
  pname = "tilequant";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "tilequant";
    tag = version;
    # Fetch tilequant source files
    fetchSubmodules = true;
    hash = "sha256-MgyKLwVdL2DRR8J88q7Q57rQiX4FTOlQ5rTY3UuhaJM=";
  };

  build-system = [
    setuptools
    setuptools-dso
  ];

  pythonRelaxDeps = [
    "click"
  ];
  dependencies = [
    click
    ordered-set
    pillow
    sortedcollections
    setuptools-dso
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "tilequant" ];

  meta = {
    description = "Tool for quantizing image colors using tile-based palette restrictions";
    homepage = "https://github.com/SkyTemple/tilequant";
    changelog = "https://github.com/SkyTemple/tilequant/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 ];
    mainProgram = "tilequant";
  };
}
