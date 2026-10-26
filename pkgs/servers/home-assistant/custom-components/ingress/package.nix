{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "lovelylain";
  domain = "ingress";
  version = "1.4.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "hass_ingress";
    tag = finalAttrs.version;
    hash = "sha256-1JmCtf+41gXuBhOB1aNzpTRxdXat/fjKQYk4Bt7Kre0=";
  };

  meta = {
    changelog = "https://github.com/lovelylain/hass_ingress/releases/tag/${finalAttrs.src.tag}";
    description = "Add additional ingress panels to your Home Assistant frontend";
    homepage = "https://github.com/lovelylain/hass_ingress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ David-Kopczynski ];
  };
})
