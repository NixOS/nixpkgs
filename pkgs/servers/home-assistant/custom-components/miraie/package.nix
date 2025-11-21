{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  miraie-ac,
  aiomqtt,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "rkzofficial";
  domain = "miraie";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "rkzofficial";
    repo = "ha-miraie-ac";
    tag = "v${version}";
    hash = "sha256-5VpLfTKOLdx8P693jaW4o79CH2NKkgkgl7ai+I6JRQs=";
  };

  dependencies = [
    miraie-ac
    aiomqtt
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rkzofficial/ha-miraie-ac/releases/tag/v${version}";
    description = "Home Assistant component for Miraie ACs";
    homepage = "https://github.com/rkzofficial/ha-miraie-ac";
    maintainers = with lib.maintainers; [ ananthb ];
    license = lib.licenses.asl20;
  };
}
