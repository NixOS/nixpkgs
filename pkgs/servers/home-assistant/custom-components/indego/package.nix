{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "sander1988";
  domain = "indego";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "Indego";
    tag = version;
    hash = "sha256-afAlA6Msg7kxCk4btH2QjBqI39dmUzLiu2f828ATizc=";
  };

  dependencies = [ pyindego ];

  meta = {
    description = "Bosch Indego lawn mower component";
    changelog = "https://github.com/sander1988/Indego/releases/tag/${version}";
    homepage = "https://github.com/sander1988/Indego";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
