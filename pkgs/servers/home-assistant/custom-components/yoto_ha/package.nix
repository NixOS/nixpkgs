{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  yoto-api,
}:

buildHomeAssistantComponent rec {
  owner = "cdnninja";
  domain = "yoto";
  version = "1.22.6";

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_ha";
    tag = "v${version}";
    hash = "sha256-6igIcDGPYUOz5dWZr9TKFmoYoUCsZOpfpESTxYRR67w=";
  };

  dependencies = [
    yoto-api
  ];

  meta = with lib; {
    changelog = "https://github.com/cdnninja/yoto_ha/releases/tag/${src.tag}";
    description = "Home Assistant Integration for Yoto.";
    homepage = "https://github.com/cdnninja/yoto_ha";
    maintainers = with maintainers; [ seberm ];
    license = licenses.mit;
  };
}
