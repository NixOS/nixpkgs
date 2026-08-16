{
  lib,
  aiocache,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  music-assistant-client,
}:

buildHomeAssistantComponent rec {
  owner = "droans";
  domain = "mass_queue";
  version = "0.10.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "mass_queue";
    tag = version;
    hash = "sha256-x64R6h66nXUdaI14W57QRMkR8Xid1oqQ6WFrdWuwR7Y=";
  };

  dependencies = [
    aiocache
    music-assistant-client
  ];

  # tests are being fixed in https://github.com/droans/mass_queue/pull/107
  doCheck = false;

  meta = {
    changelog = "https://github.com/droans/mass_queue/releases/tag/${src.tag}";
    description = "Actions to control player queues for Music Assistant";
    homepage = "https://github.com/droans/mass_queue";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
