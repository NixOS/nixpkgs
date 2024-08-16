{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "sander1988";
  domain = "indego";
  version = "5.7.4";

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "Indego";
    rev = "refs/tags/${version}";
    hash = "sha256-SiYjducy0NP5bF3STVzhBdnJraNjHywHfD7OmAnYmr0=";
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
