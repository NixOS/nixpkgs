{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  yoto-api,
}:

buildHomeAssistantComponent rec {
  owner = "cdnninja";
  domain = "yoto";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_ha";
    tag = "v${version}";
    hash = "sha256-187rLCHKYS8w7i+q99K1vP3ry8Z7Tbg8F3c95QPKTq8=";
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
