{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  yoto-api,
}:

buildHomeAssistantComponent rec {
  owner = "cdnninja";
  domain = "yoto";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_ha";
    tag = "v${version}";
    hash = "sha256-uaakUxuPxYqLnE2UK6ept91Lycvvhr0r9vZw44y1W4g=";
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
