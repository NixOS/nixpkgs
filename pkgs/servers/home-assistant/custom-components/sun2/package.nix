{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "pnbruckner";
  domain = "sun2";
  version = "3.4.3";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-sun2";
    tag = finalAttrs.version;
    hash = "sha256-UATxuKTusDkKLWwJq2CupPcF/TIKAmE5VPo3054cwKc=";
  };

  meta = rec {
    description = "Home Assistant Sun2 sensor";
    homepage = "https://github.com/pnbruckner/ha-sun2";
    changelog = "${homepage}/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ sephalon ];
    license = lib.licenses.unlicense;
  };
})
