{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  defusedxml,
}:

buildHomeAssistantComponent rec {
  owner = "hg1337";
  domain = "dwd";
<<<<<<< HEAD
  version = "2025.12.1";
=======
  version = "2025.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hg1337";
    repo = "homeassistant-dwd";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-hhuSVHa0HgIPGXH9LJg5r0OTRrlY5fX1Ec+C8ZeNiPM=";
=======
    hash = "sha256-CuoHVgk4jWDEe3OkzFCok8YqVkWLJF6Rl7i/SDeSU50=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [ defusedxml ];

  # defusedxml version mismatch
  dontCheckManifest = true;

<<<<<<< HEAD
  meta = {
    description = "Custom component for Home Assistant that integrates weather data (measurements and forecasts) of Deutscher Wetterdienst";
    homepage = "https://github.com/hg1337/homeassistant-dwd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Custom component for Home Assistant that integrates weather data (measurements and forecasts) of Deutscher Wetterdienst";
    homepage = "https://github.com/hg1337/homeassistant-dwd";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      hexa
      emilylange
    ];
  };
}
