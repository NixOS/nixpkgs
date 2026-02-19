{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  aioairctrl,
  getmac,
}:

buildHomeAssistantComponent rec {
  owner = "kongo09";
  domain = "philips_airpurifier_coap";
  version = "0.35.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "philips-airpurifier-coap";
    rev = "v${version}";
    hash = "sha256-PE2FmeqxX0xFlkHC8oZ09md5lBXgpkdlwIRhCVHm4+k=";
  };

  dependencies = [
    aioairctrl
    getmac
  ];

  ignoreVersionRequirement = [
    "getmac"
  ];

  meta = {
    description = "Philips AirPurifier custom component for Home Assistant";
    homepage = "https://github.com/kongo09/philips-airpurifier-coap";
    license = lib.licenses.unfree; # See https://github.com/kongo09/philips-airpurifier-coap/issues/209
    maintainers = with lib.maintainers; [ justinas ];
  };
}
