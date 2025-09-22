{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  elementpath,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    tag = version;
    hash = "sha256-WOeSGGOd5+g+8dSyeml+mdehEjaSHtUkNSdkGl4xSao=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    elementpath
    pyyaml
  ];

  pythonRelaxDeps = [ "elementpath" ];

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
