{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "lovelylain";
  domain = "ingress";
  version = "1.3.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass_ingress";
    tag = version;
    hash = "sha256-TvKmWDYiO4HlRWdsoya2fJalbIQnMzDodQWB9o6yGAo=";
  };

  meta = {
    changelog = "https://github.com/lovelylain/hass_ingress/releases/tag/${src.tag}";
    description = "Add additional ingress panels to your Home Assistant frontend";
    homepage = "https://github.com/lovelylain/hass_ingress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ David-Kopczynski ];
  };
}
