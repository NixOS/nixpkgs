{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  cachetools,
}:

buildHomeAssistantComponent rec {
  owner = "dckiller51";
  domain = "bodymiscale";
  version = "2026.4.5";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = version;
    hash = "sha256-L7HuBQ3NKp2vfJmo29Ju40+MC5DkgtQUi7sXnMbKHoM=";
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
