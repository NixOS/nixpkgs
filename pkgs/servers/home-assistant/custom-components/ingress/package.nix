{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "lovelylain";
  domain = "ingress";
  version = "1.2.9";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass_ingress";
    tag = version;
    hash = "sha256-jjig0Dl/vdeuN7e25CH5L/Xvc60RM3BiAt3jUw/C9q4=";
  };

  meta = {
    changelog = "https://github.com/lovelylain/hass_ingress/releases/tag/${src.tag}";
    description = "Add additional ingress panels to your Home Assistant frontend";
    homepage = "https://github.com/lovelylain/hass_ingress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ David-Kopczynski ];
  };
}
