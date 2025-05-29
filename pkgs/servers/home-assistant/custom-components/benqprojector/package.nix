{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  benqprojector,
}:

buildHomeAssistantComponent rec {
  owner = "rrooggiieerr";
  domain = "benqprojector";
  version = "0.1.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-benqprojector";
    tag = version;
    hash = "sha256-iAFmXL10QqudECsS9u9w7KBETzu9aWCg1EBbFR1ff+o=";
  };

  dependencies = [ benqprojector ];

  meta = rec {
    description = "Home Assistant integration for BenQ projectors";
    homepage = "https://github.com/rrooggiieerr/homeassistant-benqprojector";
    changelog = "${homepage}/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
