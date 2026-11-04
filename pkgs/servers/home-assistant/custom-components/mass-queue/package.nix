{
  lib,
  aiocache,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  music-assistant-client,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "droans";
  domain = "mass_queue";
  version = "0.10.4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "mass_queue";
    tag = "v${version}";
    hash = "sha256-VLX32fDcqnwYqbcHUPNtfjPgw0grxNSbUjkMce4pKDA=";
  };

  dependencies = [
    aiocache
    music-assistant-client
  ];

  # tests are being fixed in https://github.com/droans/mass_queue/pull/107
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  meta = {
    changelog = "https://github.com/droans/mass_queue/releases/tag/${src.tag}";
    description = "Actions to control player queues for Music Assistant";
    homepage = "https://github.com/droans/mass_queue";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
