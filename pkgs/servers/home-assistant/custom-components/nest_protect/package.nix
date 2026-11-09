{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  googleapis-common-protos,
  nix-update-script,
  protobuf,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytest-timeout,
  pytestCheckHook,
}:
buildHomeAssistantComponent rec {
  owner = "iMicknl";
  domain = "nest_protect";
  version = "0.5.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-nest-protect";
    tag = "v${version}";
    hash = "sha256-jN2dc4AsRFbnSsbomUtrbLO4WgcTBGxUpuZbaUGmIEA=";
  };

  dependencies = [
    googleapis-common-protos
    protobuf
  ];

  nativeCheckInputs = [
    pytest-freezer
    pytest-homeassistant-custom-component
    pytest-timeout
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    changelog = "https://github.com/iMicknl/ha-nest-protect/releases/tag/v${version}";
    description = "Nest Protect integration for Home Assistant";
    homepage = "https://github.com/iMicknl/ha-nest-protect";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
