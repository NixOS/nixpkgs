{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent rec {
  owner = "sander1988";
  domain = "indego";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "Indego";
    tag = version;
    hash = "sha256-pjkrodMFv8ZiSxmAK/JXuQbj6dfdkBf0FmhSMchTjsI=";
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
