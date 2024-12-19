{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "sander1988";
  domain = "indego";
  version = "5.7.8";

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "Indego";
    rev = "refs/tags/${version}";
    hash = "sha256-7PQUsSPS+o5Vt4Do4/TXyGXAqyHJg96w8n7UMpZ0uFo=";
  };

  dependencies = [ pyindego ];

  meta = with lib; {
    description = "Bosch Indego lawn mower component";
    changelog = "https://github.com/sander1988/Indego/releases/tag/${version}";
    homepage = "https://github.com/sander1988/Indego";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
