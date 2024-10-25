{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  defusedxml,
}:

buildHomeAssistantComponent rec {
  owner = "hg1337";
  domain = "dwd";
  version = "2024.9.0";

  src = fetchFromGitHub {
    owner = "hg1337";
    repo = "homeassistant-dwd";
    rev = version;
    hash = "sha256-9zS6ufy7tYt1KwFeqdg0Az8xz3x5UzU9ZO9aOyWjdQE=";
  };

  dependencies = [ defusedxml ];

  # defusedxml version mismatch
  dontCheckManifest = true;

  meta = with lib; {
    description = "Custom component for Home Assistant that integrates weather data (measurements and forecasts) of Deutscher Wetterdienst";
    homepage = "https://github.com/hg1337/homeassistant-dwd";
    license = licenses.asl20;
    maintainers = with maintainers; [
      hexa
      emilylange
    ];
  };
}
