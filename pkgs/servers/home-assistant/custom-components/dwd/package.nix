{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  defusedxml,
}:

buildHomeAssistantComponent rec {
  owner = "hg1337";
  domain = "dwd";
  version = "2026.10.0";

  src = fetchFromGitHub {
    owner = "hg1337";
    repo = "homeassistant-dwd";
    rev = version;
    hash = "sha256-IvOPJ4K3KYwG1Apijj2LxU4zzYv1xE2M1KC0YOjdi1Y=";
  };

  dependencies = [ defusedxml ];

  # defusedxml version mismatch
  dontCheckManifest = true;

  meta = {
    description = "Custom component for Home Assistant that integrates weather data (measurements and forecasts) of Deutscher Wetterdienst";
    homepage = "https://github.com/hg1337/homeassistant-dwd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hexa
      emilylange
    ];
  };
}
