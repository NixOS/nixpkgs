{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "rospogrigio";
  domain = "localtuya";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "rospogrigio";
    repo = "localtuya";
    rev = "v${version}";
    hash = "sha256-GexGUu4hevRDGF7gv7Jklr5YZJV+QH3kZN7p+eK9HlM=";
  };

  meta = with lib; {
    changelog = "https://github.com/rospogrigio/localtuya/releases/tag/${version}";
    description = "Home Assistant custom Integration for local handling of Tuya-based devices";
    homepage = "https://github.com/rospogrigio/localtuya";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl3Only;
  };
}
