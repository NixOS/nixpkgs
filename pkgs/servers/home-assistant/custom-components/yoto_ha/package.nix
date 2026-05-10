{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  yoto-api,
}:

buildHomeAssistantComponent rec {
  owner = "cdnninja";
  domain = "yoto";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_ha";
    tag = "v${version}";
    hash = "sha256-t//Ox8Ytwjp7kTdz8k1QZyDyejW+mZBt1auncikBYb0=";
  };

  dependencies = [
    yoto-api
  ];

  meta = {
    changelog = "https://github.com/cdnninja/yoto_ha/releases/tag/${src.tag}";
    description = "Home Assistant Integration for Yoto";
    homepage = "https://github.com/cdnninja/yoto_ha";
    maintainers = with lib.maintainers; [ seberm ];
    license = lib.licenses.mit;
  };
}
