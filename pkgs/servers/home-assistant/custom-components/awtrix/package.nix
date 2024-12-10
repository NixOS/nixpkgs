{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, requests
}:

buildHomeAssistantComponent rec {
  owner = "10der";
  domain = "awtrix";
  version = "unstable-2024-05-26";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-custom_components-awtrix";
    rev = "329d8eec28478574b9f34778f96b5768f30be2ab";
    hash = "sha256-ucSaQWMS6ZwXHnw5Ct/STxpl1JjBRua3edrLvBAsdyw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  meta = with lib; {
    description = "Home-assistant integration for awtrix";
    homepage = "https://github.com/10der/homeassistant-custom_components-awtrix";
    maintainers = with maintainers; [ pinpox ];
    license = licenses.mit;
  };
}

