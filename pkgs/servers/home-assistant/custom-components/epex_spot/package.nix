{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  beautifulsoup4,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "epex_spot";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "ha_epex_spot";
    tag = version;
    hash = "sha256-UaPgf0861TaSgawjJCyNjs8hRE5L5vWnyoXENrzCfb4=";
  };

  dependencies = [
    beautifulsoup4
  ];

  #skip phases without activity
  dontConfigure = true;
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/mampfes/ha_epex_spot/releases/tag/${version}";
    description = "This component adds electricity prices from stock exchange EPEX Spot to Home Assistant";
    homepage = "https://github.com/mampfes/ha_epex_spot";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
  };
}
