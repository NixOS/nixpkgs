{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  cachetools,
}:

buildHomeAssistantComponent rec {
  owner = "dckiller51";
  domain = "bodymiscale";
  version = "2026.7.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = version;
    hash = "sha256-xBxK5V+DwXkoaC0D5HNlH2hHn+W2KUJAZ7rk0KxIy4U=";
  };

  dependencies = [
    cachetools
  ];

  ignoreVersionRequirement = [
    "cachetools"
  ];

  meta = {
    description = "Home Assistant custom component providing body metrics for Xiaomi Mi Scale 1 and 2";
    homepage = "https://github.com/dckiller51/bodymiscale";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ justinas ];
  };
}
