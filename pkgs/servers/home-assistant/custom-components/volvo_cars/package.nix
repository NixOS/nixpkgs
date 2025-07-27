{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "thomasddn";
  domain = "volvo_cars";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "ha-volvo-cars";
    tag = "v${version}";
    hash = "sha256-2eTUIbwAadJsOp1ETDY6+cEPVMOzhj1otEyzobysqaY=";
  };

  meta = {
    changelog = "https://github.com/thomasddn/ha-volvo-cars/releases/tag/${src.tag}";
    homepage = "https://github.com/thomasddn/ha-volvo-cars";
    description = "Volvo Cars Home Assistant integration";
    maintainers = with lib.maintainers; [
      matteopacini
      seberm
    ];
    license = lib.licenses.gpl3Only;
  };
}
