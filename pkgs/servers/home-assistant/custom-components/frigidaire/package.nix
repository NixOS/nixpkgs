{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  frigidaire,
}:
buildHomeAssistantComponent rec {
  owner = "bm1549";
  domain = "frigidaire";
  version = "0.1.20";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-frigidaire";
    tag = version;
    hash = "sha256-XUtffkwy1HGVt41rrPl5Yk2DkYQie2FcYMoxSnzlArY=";
  };

  dependencies = [ frigidaire ];

  # NOTE: The manifest.json specifies an exact version requirement for the
  # frigidaire dependency
  ignoreVersionRequirement = [ "frigidaire" ];

  meta = {
    description = "Custom component for the Frigidaire integration";
    homepage = "https://github.com/bm1549/home-assistant-frigidaire";
    maintainers = with lib.maintainers; [ nullcube ];
    license = lib.licenses.mit;
  };
}
