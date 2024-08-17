{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  defusedxml,
}:

buildHomeAssistantComponent rec {
  owner = "hg1337";
  domain = "dwd";
  version = "2024.4.0";

  src = fetchFromGitHub {
    owner = "hg1337";
    repo = "homeassistant-dwd";
    rev = version;
    hash = "sha256-2bmLEBt6031p9SN855uunq7HrRJ9AFokw8t4CSBidTM=";
  };

  dependencies = [ defusedxml ];

  # defusedxml version mismatch
  dontCheckManifest = true;

  meta = with lib; {
    description = "Custom component for Home Assistant that integrates weather data (measurements and forecasts) of Deutscher Wetterdienst";
    homepage = "https://github.com/hg1337/homeassistant-dwd";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
