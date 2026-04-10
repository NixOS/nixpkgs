{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  cachetools,
}:

buildHomeAssistantComponent rec {
  owner = "dckiller51";
  domain = "bodymiscale";
  version = "2026.10.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = version;
    hash = "sha256-oj9UT05Rt0SVE5Oxbes8MRLZ7JJ7OtOtuYQx7qXg+6Y=";
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ justinas ];
  };
}
