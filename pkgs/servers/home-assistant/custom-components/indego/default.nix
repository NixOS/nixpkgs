{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "jm-73";
  domain = "indego";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "jm-73";
    repo = "Indego";
    rev = "refs/tags/${version}";
    hash = "sha256-ur6KOqU6KAseABL0ibpGJ6109wSSZq9HWSVbMIrRSqc=";
  };

  dependencies = [ pyindego ];

  meta = with lib; {
    description = "Bosch Indego lawn mower component";
    changelog = "https://github.com/jm-73/Indego/releases/tag/${version}";
    homepage = "https://github.com/jm-73/Indego";
    # https://github.com/jm-73/pyIndego/issues/125
    license = licenses.unfree;
    maintainers = with maintainers; [ hexa ];
  };
}
