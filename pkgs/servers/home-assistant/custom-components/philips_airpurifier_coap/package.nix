{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  aioairctrl,
  getmac,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "kongo09";
  domain = "philips_airpurifier_coap";
  version = "0.37";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "philips-airpurifier-coap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oPdjf6eOkkywFQMavbeBty5E5zb215qIBHWND5zaJBs=";
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
})
