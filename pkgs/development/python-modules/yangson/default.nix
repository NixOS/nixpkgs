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
  version = "1.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    tag = version;
    hash = "sha256-vpQCbHyQslPhY2tz5+6aLGeyI2+6tt43Zr04EABDuPM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    elementpath
    pyyaml
  ];

  pythonRelaxDeps = [ "elementpath" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yangson" ];

  meta = {
    description = "Library for working with data modelled in YANG";
    mainProgram = "yangson";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = [ ];
  };
}
