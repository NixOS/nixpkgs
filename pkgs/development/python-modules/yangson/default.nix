{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  elementpath,
  pyyaml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    tag = version;
    hash = "sha256-lKPWyN7ouL7+tefLH63LOcCtDkXtK9oZgejksURkaNE=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "setuptools"
  ];

  dependencies = [
    elementpath
    pyyaml
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yangson" ];

  meta = with lib; {
    description = "Library for working with data modelled in YANG";
    mainProgram = "yangson";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = [ ];
  };
}
