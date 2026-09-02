{
  aiofiles,
  aiohttp,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  propcache,
  pyyaml,
}:

buildHomeAssistantComponent rec {
  owner = "davidrapan";
  domain = "solarman";
  version = "25.08.16";

  src = fetchFromGitHub {
    owner = "davidrapan";
    repo = "ha-solarman";
    tag = "v${version}";
    hash = "sha256-SsUObH3g3i9xQ4JvRDcCm1Fg2giH+MN3rC3NMPYO5m0=";
  };

  dependencies = [
    aiofiles
    aiohttp
    propcache
    pyyaml
  ];

  meta = {
    description = "Home Assistant component for Solarman Stick Loggers";
    changelog = "https://github.com/davidrapan/ha-solarman/releases/tag/${version}";
    homepage = "https://github.com/davidrapan/ha-solarman";
    maintainers = with lib.maintainers; [ Scrumplex ];
    # `license` and `custom_components/solarman/pysolarman/license` are MIT
    # `custom_components/solarman/pysolarman/umodbus/license` is MPL 2.0
    license = with lib.licenses; [
      mit
      mpl20
    ];
  };
}
