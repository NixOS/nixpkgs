{
  lib,
  aiohttp,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "geappliances";
  domain = "smarthq";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "geappliances";
    repo = "geappliances-smarthq-integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OiEUrYR4J+AUDDQN7BkGZPuBSG5lry7OB0sh7CsShtI=";
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
