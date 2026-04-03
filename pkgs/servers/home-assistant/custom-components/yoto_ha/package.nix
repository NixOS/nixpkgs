{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  yoto-api,
}:

buildHomeAssistantComponent rec {
  owner = "cdnninja";
  domain = "yoto";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_ha";
    tag = "v${version}";
    hash = "sha256-b2V2nHH3E0z1AE9C3m5/fXITmWusoyx0rcTIF1nD57U=";
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
