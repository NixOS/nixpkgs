{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tivars";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TI-Toolkit";
    repo = "tivars_lib_py";
    tag = "v${version}";
    hash = "sha256-mVMrOZIkqHlEUDSxBEMyhFTTiFyrTxz9K2SlH3WtVS0=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "tivars" ];

  # no upstream tests exist
  doCheck = false;

  meta = {
    description = "Python library for interacting with TI-(e)z80 (82/83/84 series) calculator files";
    license = lib.licenses.mit;
    homepage = "https://ti-toolkit.github.io/tivars_lib_py/";
    changelog = "https://github.com/TI-Toolkit/tivars_lib_py/releases/tag/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
