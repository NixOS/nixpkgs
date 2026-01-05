{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  zigpy,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "AlexxIT";
  domain = "xiaomi_gateway3";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "XiaomiGateway3";
    rev = "v${version}";
    hash = "sha256-pa9B2c1QeQ3DR2qjttP0c/44pERGtune+4nlnzPBSYo=";
  };

  dependencies = [ zigpy ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/AlexxIT/XiaomiGateway3/releases/tag/v${version}";
    description = "Home Assistant custom component for control Xiaomi Multimode Gateway (aka Gateway 3), Xiaomi Multimode Gateway 2, Aqara Hub E1 on default firmwares over LAN";
    homepage = "https://github.com/AlexxIT/XiaomiGateway3";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
