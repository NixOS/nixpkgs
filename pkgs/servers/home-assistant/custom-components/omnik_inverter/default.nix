{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, omnikinverter
}:

buildHomeAssistantComponent rec {
  owner = "robbinjanssen";
  domain = "omnik_inverter";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "robbinjanssen";
    repo = "home-assistant-omnik-inverter";
    rev = "refs/tags/v${version}";
    hash = "sha256-O1NxT7u27xLydPqEqH72laU0tlYVrMPo0TwWIVNJ+0Q=";
  };

  propagatedBuildInputs = [
    omnikinverter
  ];

  doCheck = false; # no tests

  meta = with lib; {
    changelog = "https://github.com/robbinjanssen/home-assistant-omnik-inverter/releases/tag/v${version}";
    description = "The Omnik Inverter integration will scrape data from an Omnik inverter connected to your local network";
    homepage = "https://github.com/robbinjanssen/home-assistant-omnik-inverter";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
  };
}
