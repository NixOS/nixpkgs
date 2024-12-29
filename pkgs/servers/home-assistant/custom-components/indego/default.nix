{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "jm-73";
  domain = "indego";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "jm-73";
    repo = "Indego";
    rev = "refs/tags/${version}";
    hash = "sha256-9q8aHbAMIA2xKhZl/CDXWSV1ylDCEVkpL8OUlELoG0Q=";
  };

  dependencies = [ pyindego ];

  meta = with lib; {
    description = "Bosch Indego lawn mower component";
    changelog = "https://github.com/jm-73/Indego/releases/tag/${version}";
    homepage = "https://github.com/jm-73/Indego";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
