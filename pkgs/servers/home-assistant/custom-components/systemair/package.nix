{
  lib,
  pymodbus,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  async-timeout,
  aiohttp,
}:

buildHomeAssistantComponent rec {
  owner = "AN3Orik";
  domain = "systemair";
  version = "1.0.22";

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    tag = "v${version}";
    hash = "sha256-GzIIjaRFeZAo065Dn0fpU4Ou5+8wIVQ7ImLmukjTxOQ=";
  };

  postPatch = ''
    substituteInPlace custom_components/systemair/manifest.json \
      --replace-fail "pymodbus==" "pymodbus>=" \
  '';

  dependencies = [
    pymodbus
    async-timeout
    aiohttp
  ];

  meta = {
    changelog = "https://github.com/AN3Orik/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE ventilation units";
    homepage = "https://github.com/AN3Orik/systemair";
    maintainers = with lib.maintainers; [ uvnikita ];
    license = lib.licenses.mit;
  };
}
