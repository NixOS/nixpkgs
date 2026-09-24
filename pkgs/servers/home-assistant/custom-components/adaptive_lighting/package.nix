{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ulid-transform,
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    tag = "v${version}";
    hash = "sha256-L00M+74ZgJmUje5c/TBkBlsjCrqPt7i/8hH8SU5cnRc=";
  };

  dependencies = [
    ulid-transform
  ];

  meta = {
    changelog = "https://github.com/basnijholt/adaptive-lighting/releases/tag/${src.tag}";
    description = "Home Assistant Adaptive Lighting Plugin - Sun Synchronized Lighting";
    homepage = "https://github.com/basnijholt/adaptive-lighting";
    maintainers = with lib.maintainers; [ mindstorms6 ];
    license = lib.licenses.asl20;
  };
}
