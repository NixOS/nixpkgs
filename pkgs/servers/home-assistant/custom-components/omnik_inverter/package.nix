{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  omnikinverter,
}:

buildHomeAssistantComponent rec {
  owner = "robbinjanssen";
  domain = "omnik_inverter";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "robbinjanssen";
    repo = "home-assistant-omnik-inverter";
    tag = "v${version}";
    hash = "sha256-O1NxT7u27xLydPqEqH72laU0tlYVrMPo0TwWIVNJ+0Q=";
  };

  dependencies = [
    omnikinverter
  ];

  doCheck = false; # no tests

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/robbinjanssen/home-assistant-omnik-inverter/releases/tag/v${version}";
    description = "Omnik Inverter integration will scrape data from an Omnik inverter connected to your local network";
    homepage = "https://github.com/robbinjanssen/home-assistant-omnik-inverter";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/robbinjanssen/home-assistant-omnik-inverter/releases/tag/v${version}";
    description = "Omnik Inverter integration will scrape data from an Omnik inverter connected to your local network";
    homepage = "https://github.com/robbinjanssen/home-assistant-omnik-inverter";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
