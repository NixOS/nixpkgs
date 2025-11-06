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
  version = "1.0.17";

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    tag = "v${version}";
    hash = "sha256-R5Q6BbvcAqFNldOqfG1TDoM1gbsYrS3OClHlAdfQG6o=";
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
