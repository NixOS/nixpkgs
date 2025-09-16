{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  requests,
}:

buildHomeAssistantComponent rec {
  owner = "hbrennhaeuser";
  domain = "ntfy";
  version = "1.2.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant_integration_ntfy";
    rev = "v${version}";
    hash = "sha256-cy4aHrUdFlMGQt9we0pA8TEGffQEGptZoaSKxwXD4kM=";
  };

  dependencies = [
    requests
  ];

  meta = with lib; {
    description = "Send notifications with ntfy.sh and selfhosted ntfy-servers";
    homepage = "https://github.com/hbrennhaeuser/homeassistant_integration_ntfy";
    maintainers = with maintainers; [
      koral
      baksa
    ];
    license = licenses.gpl3;
  };
}
