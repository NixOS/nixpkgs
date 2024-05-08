{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, requests
}:

buildHomeAssistantComponent rec {
  owner = "hbrennhaeuser";
  domain = "ntfy";
  version = "v1.0.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant_integration_ntfy";
    rev = "refs/tags/${version}";
    hash = "sha256-QBk2k0v/yV8BEf/lgIye+XhLMwvzSDlSewsR+eGXKyU=";
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

