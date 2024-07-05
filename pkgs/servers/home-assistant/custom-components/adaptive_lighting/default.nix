{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, ulid-transform
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    rev = "refs/tags/${version}";
    hash = "sha256-k5pCgPM5xjVfWjOcr0UDFzYl/8z7yUwgYdBmC3+2F5k=";
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
