{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
}:
buildHomeAssistantComponent rec {
  owner = "Hypfer";
  domain = "valetudo";
  version = "2025.12.0";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "hass-valetudo";
    tag = "${version}";
    hash = "sha256-dHrN9Bbmm3J47MRmwExZH6Mi4RvRBZdQ4R1xeCewcSc=";
  };
  meta = {
    description = "Valetudo for Home Assistant";
    homepage = "https://github.com/Hypfer/hass-valetudo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
