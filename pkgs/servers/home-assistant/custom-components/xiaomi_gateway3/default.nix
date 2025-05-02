{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, zigpy
}:

buildHomeAssistantComponent rec {
  owner = "AlexxIT";
  domain = "xiaomi_gateway3";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "XiaomiGateway3";
    rev = "v${version}";
    hash = "sha256-YGaVQaz3A0yM8AIC02CvMKWMJ3tW3OADYgKY8ViIt5U=";
  };

  propagatedBuildInputs = [
    zigpy
  ];

  dontBuild = true;

  meta = with lib; {
    changelog = "https://github.com/AlexxIT/XiaomiGateway3/releases/tag/v{version}";
    description = "Home Assistant custom component for control Xiaomi Multimode Gateway (aka Gateway 3), Xiaomi Multimode Gateway 2, Aqara Hub E1 on default firmwares over LAN";
    homepage = "https://github.com/AlexxIT/XiaomiGateway3";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
