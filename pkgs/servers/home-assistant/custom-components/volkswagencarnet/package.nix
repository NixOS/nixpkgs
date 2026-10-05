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
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "robinostlund";
    repo = "homeassistant-volkswagencarnet";
    tag = "v${version}";
    hash = "sha256-2UNLDZLwpVMxdUCIVUlyedTfGxyioCZjMGaE5HK6NHg=";
  };

  postPatch = ''
    python3 manage/update_manifest.py --version '${version}'
  '';

  dependencies = [ volkswagencarnet ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/robinostlund/homeassistant-volkswagencarnet/releases/tag/${src.tag}";
    description = "Volkswagen Connect component for Home Assistant";
    homepage = "https://github.com/robinostlund/homeassistant-volkswagencarnet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
