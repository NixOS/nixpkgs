{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  volkswagencarnet,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "robinostlund";
  domain = "volkswagencarnet";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "homeassistant-volkswagencarnet";
    tag = "v${version}";
    hash = "sha256-V9/g+MzW5Bva/sxR44Fq1Rf5IZstpfKLUNZf2SqP/YM=";
  };

  dependencies = [ volkswagencarnet ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  # https://github.com/robinostlund/homeassistant-volkswagencarnet/issues/651
  doCheck = false;

  meta = {
    changelog = "https://github.com/robinostlund/homeassistant-volkswagencarnet/releases/tag/${src.tag}";
    description = "Volkswagen Connect component for Home Assistant";
    homepage = "https://github.com/robinostlund/homeassistant-volkswagencarnet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
