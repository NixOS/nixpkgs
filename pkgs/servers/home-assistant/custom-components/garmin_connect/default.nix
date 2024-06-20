{ stdenv
, lib
, fetchFromGitHub
, buildHomeAssistantComponent

, garminconnect
, tzlocal
}:

buildHomeAssistantComponent rec {
  owner = "cyberjunky";
  domain = "garmin_connect";
  version = "unstable-2024-04-06";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-garmin_connect";
    rev = "d42edcabc67ba6a7f960e849c8aaec1aabef87c0";
    sha256 = "sha256-KqbP6TpH9B0/AjtsW5TcWSNgUhND+w8rO6X8fHqtsDI=";
  };

  propagatedBuildInputs = [
    garminconnect
    tzlocal
  ];

  meta = with lib; {
    homepage = "https://github.com/cyberjunky/home-assistant-garmin_connect";
    license = licenses.mit;
    description = "Garmin Connect integration for Home Assistant";
    maintainers = with maintainers; [ dmadisetti ];
  };
}
