{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  music-assistant-client,
}:

buildHomeAssistantComponent rec {
  owner = "droans";
  domain = "mass_queue";
  version = "0.10.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "mass_queue";
    tag = version;
    hash = "sha256-kr3XV/C7TGffDX8U/81UnjN7HSZnsAd+k/ALls/QALc=";
  };

  dependencies = [
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
