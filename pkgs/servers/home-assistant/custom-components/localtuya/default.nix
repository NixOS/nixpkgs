{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "rospogrigio";
  domain = "localtuya";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "rospogrigio";
    repo = "localtuya";
    rev = "v${version}";
    hash = "sha256-hA/1FxH0wfM0jz9VqGCT95rXlrWjxV5oIkSiBf0G0ac=";
  };

  meta = with lib; {
    changelog = "https://github.com/rospogrigio/localtuya/releases/tag/${version}";
    description = "A Home Assistant custom Integration for local handling of Tuya-based devices";
    homepage = "https://github.com/rospogrigio/localtuya";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl3Only;
  };
}
