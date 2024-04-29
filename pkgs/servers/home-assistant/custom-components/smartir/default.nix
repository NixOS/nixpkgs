{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, aiofiles
, broadlink
}:

buildHomeAssistantComponent rec {
  owner = "smartHomeHub";
  domain = "smartir";
  version = "1.17.9";

  src = fetchFromGitHub {
    owner = "smartHomeHub";
    repo = "SmartIR";
    rev = version;
    hash = "sha256-E6TM761cuaeQzlbjA+oZ+wt5HTJAfkF2J3i4P1Wbuic=";
  };

  propagatedBuildInputs = [
    aiofiles
    broadlink
  ];

  dontBuild = true;

  postInstall = ''
    cp -r codes $out/custom_components/smartir/
  '';

  meta = with lib; {
    changelog = "https://github.com/smartHomeHub/SmartIR/releases/tag/v${version}";
    description = "Integration for Home Assistant to control climate, TV and fan devices via IR/RF controllers (Broadlink, Xiaomi, MQTT, LOOKin, ESPHome)";
    homepage = "https://github.com/smartHomeHub/SmartIR";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
