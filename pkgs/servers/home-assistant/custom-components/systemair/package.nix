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
  version = "1.0.13";

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    tag = "v${version}";
    hash = "sha256-qQC9QzNgCa1NEjCA4wh4Au9VL2tOLh94l/O/ZjrCAuY=";
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

  meta = with lib; {
    changelog = "https://github.com/AN3Orik/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE ventilation units";
    homepage = "https://github.com/AN3Orik/systemair";
    maintainers = with maintainers; [ uvnikita ];
    license = licenses.mit;
  };
}
