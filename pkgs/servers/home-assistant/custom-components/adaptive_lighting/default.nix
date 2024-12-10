{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ulid-transform,
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    rev = "refs/tags/${version}";
    hash = "sha256-AZsloE1vNQ9o2pg878J6I5qYXyI4fqYEvr18SrTocWo=";
  };

  propagatedBuildInputs = [
    ulid-transform
  ];

  meta = with lib; {
    changelog = "https://github.com/basnijholt/adaptive-lighting/releases/tag/${version}";
    description = "Home Assistant Adaptive Lighting Plugin - Sun Synchronized Lighting";
    homepage = "https://github.com/basnijholt/adaptive-lighting";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.asl20;
  };
}
