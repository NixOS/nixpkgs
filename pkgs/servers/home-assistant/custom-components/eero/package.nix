{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pypng,
  pyqrcode,
}:

buildHomeAssistantComponent rec {
  version = "1.8.1";
  owner = "schmittx";
  domain = "eero";

  src = fetchFromGitHub {
    owner = "schmittx";
    repo = "home-assistant-eero";
    tag = version;
    hash = "sha256-iAY5ZlJaSZedykIOiRxULbrs+b8iK0pGed3fHbF3b8E=";
  };

  # no tests
  doCheck = false;

  ignoreVersionRequirement = [
    "pypng"
    "pyqrcode"
  ];

  dependencies = [
    pypng
    pyqrcode
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Custom component to allow control of Eero networks in Home Assistant";
    homepage = "https://github.com/schmittx/home-assistant-eero";
    changelog = "https://github.com/schmittx/home-assistant-eero/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
}
