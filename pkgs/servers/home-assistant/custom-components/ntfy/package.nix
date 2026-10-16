{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  requests,
}:

buildHomeAssistantComponent rec {
  owner = "hbrennhaeuser";
  domain = "ntfy";
  version = "1.2.0-pre.4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant_integration_ntfy";
    rev = "v${version}";
    hash = "sha256-iDQE/pyXMSvOt9+CgXUb+1XoMHUjPhIByspsKLU0Z50=";
  };

  dependencies = [
    requests
  ];

  meta = {
    description = "Send notifications with ntfy.sh and selfhosted ntfy-servers";
    homepage = "https://github.com/hbrennhaeuser/homeassistant_integration_ntfy";
    maintainers = with lib.maintainers; [
      koral
      baksa
    ];
    license = lib.licenses.gpl3;
  };
}
