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
  version = "0.28.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "philips-airpurifier-coap";
    rev = "v${version}";
    hash = "sha256-yoaph/R3c4j+sXEC02Hv+ixtuif70/y6Gag5NBpKFLs=";
  };

  postPatch = ''
    substituteInPlace custom_components/philips_airpurifier_coap/manifest.json --replace-fail 'getmac==0.9.4' 'getmac>=0.9.4'
  '';

  dependencies = [
    aioairctrl
    getmac
  ];

  meta = {
    description = "Philips AirPurifier custom component for Home Assistant";
    homepage = "https://github.com/kongo09/philips-airpurifier-coap";
    license = lib.licenses.unfree; # See https://github.com/kongo09/philips-airpurifier-coap/issues/209
    maintainers = with lib.maintainers; [ justinas ];
  };
}
