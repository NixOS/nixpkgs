{
  lib,
  pymodbus,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "AN3Orik";
  domain = "systemair";
  version = "1.0.6";

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    tag = "v${version}";
    hash = "sha256-eRRg9V/AlAGTnlvJFUPXilpwyRpE6XAHphJ0qXsTLxU=";
  };

  dependencies = [
    pymodbus
  ];

  meta = with lib; {
    changelog = "https://github.com/AN3Orik/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE Connect 2";
    homepage = "https://github.com/tesharp/systemair";
    maintainers = with maintainers; [ uvnikita ];
    license = licenses.mit;
  };
}
