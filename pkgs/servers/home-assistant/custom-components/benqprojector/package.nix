{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  benqprojector,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "rrooggiieerr";
  domain = "benqprojector";
  version = "0.1.4";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "homeassistant-benqprojector";
    tag = finalAttrs.version;
    hash = "sha256-BiAqEVZSbroxw46thsU1psjP9JEEZaGRLWgpT/lQTHI=";
  };

  dependencies = [ benqprojector ];

  meta = rec {
    description = "Home Assistant integration for BenQ projectors";
    homepage = "https://github.com/rrooggiieerr/homeassistant-benqprojector";
    changelog = "${homepage}/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sephalon ];
  };
})
