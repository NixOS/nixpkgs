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
  version = "0.34.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "philips-airpurifier-coap";
    rev = "v${version}";
    hash = "sha256-jZmFvozkmmCCeKmdOV/FKXj0V8iGP3tnAqED/PBZrrY=";
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
