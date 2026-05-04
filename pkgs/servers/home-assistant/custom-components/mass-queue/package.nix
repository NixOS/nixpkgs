{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  music-assistant-client,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "droans";
  domain = "mass_queue";
  version = "0.10.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "mass_queue";
    tag = "v${version}";
    hash = "sha256-Q41/DAwXByeq0Qim3U735XYpLsI2DQqe5r1mJ3N/I2w=";
  };

  patches = [
    # https://github.com/droans/mass_queue/pull/107
    ./fix-tests.patch
  ];

  dependencies = [
    music-assistant-client
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Actions to control player queues for Music Assistant";
    homepage = "https://github.com/droans/mass_queue";
    changelog = "https://github.com/droans/mass_queue/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
