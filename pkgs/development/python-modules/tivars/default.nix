{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tivars";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TI-Toolkit";
    repo = "tivars_lib_py";
    tag = "v${version}";
    hash = "sha256-4c5wRv78Rql9k98WNT58As/Ir1YJpTeoBdkft9TIn7o=";
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
