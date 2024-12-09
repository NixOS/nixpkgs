{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, requests
}:

buildHomeAssistantComponent rec {
  owner = "hbrennhaeuser";
  domain = "ntfy";
  version = "1.1.0-pre.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant_integration_ntfy";
    rev = "v${version}";
    hash = "sha256-OGCAJsAsnUjwaLR8lCBdU+ghVOGFF0mT73t5JtcngUA=";
  };

  propagatedBuildInputs = [
    requests
  ];

  meta = with lib; {
    description = "Send notifications with ntfy.sh and selfhosted ntfy-servers";
    homepage = "https://github.com/hbrennhaeuser/homeassistant_integration_ntfy";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl3;
  };
}

