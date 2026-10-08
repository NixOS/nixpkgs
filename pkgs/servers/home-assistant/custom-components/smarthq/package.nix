{
  lib,
  aiohttp,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "geappliances";
  domain = "smarthq";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "geappliances";
    repo = "geappliances-smarthq-integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yu5A4DveMGRabmeMcqXpPU94bmIh/dIp0WIKWfSUWi4=";
  };

  dependencies = [
    aiohttp
  ];

  meta = {
    changelog = "https://github.com/geappliances/geappliances-smarthq-integration/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant integration for GE Appliances SmartHQ connected devices";
    homepage = "https://github.com/geappliances/geappliances-smarthq-integration";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
