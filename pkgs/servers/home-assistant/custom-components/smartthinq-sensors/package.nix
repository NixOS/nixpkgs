{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  charset-normalizer,
  pycountry,
  xmltodict,
}:

buildHomeAssistantComponent rec {
  owner = "ollo69";
  domain = "smartthinq_sensors";
  version = "0.42.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-smartthinq-sensors";
    rev = "v${version}";
    hash = "sha256-ks1feF4TjzQaI6r6HzZ2cXPcUO+yMoeav34C/2jlH3k=";
  };

  dependencies = [
    charset-normalizer
    pycountry
    xmltodict
  ];

  meta = {
    description = "Home Assistant custom integration for SmartThinQ LG devices configurable with Lovelace User Interface";
    homepage = "https://github.com/ollo69/ha-smartthinq-sensors";
    changelog = "https://github.com/ollo69/ha-smartthinq-sensors/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ k900 ];
    license = lib.licenses.asl20;
  };
}
