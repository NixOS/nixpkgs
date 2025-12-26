{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ulid-transform,
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    tag = "v${version}";
    hash = "sha256-v10Mrc/sSB09mC0UHMhjoEnPhj5S3tISmMcPQrPHPq8=";
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
