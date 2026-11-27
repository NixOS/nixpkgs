{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  cachetools,
}:

buildHomeAssistantComponent rec {
  owner = "dckiller51";
  domain = "bodymiscale";
  version = "2026.11.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = version;
    hash = "sha256-j7SoqqzB8DU67/RuGgCPvEeqFIy03x1VAqmZyGky0K8=";
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
