{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "sander1988";
  domain = "indego";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "Indego";
    tag = version;
    hash = "sha256-yVzKHmxRWCsCcYu/HHwnEh3u9BDi3CngPk85sc/vIJo=";
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
