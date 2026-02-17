{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent rec {
  owner = "iMicknl";
  domain = "nest_protect";
  version = "0.4.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-nest-protect";
    tag = "v${version}";
    hash = "sha256-3ydysyhXi2ucExNGH3S5HIUN7iUIC4ysjuXKDyqq/hs=";
  };

  # AttributeError: 'async_generator' object has no attribute 'data'
  doCheck = false;

  meta = {
    changelog = "https://github.com/iMicknl/ha-nest-protect/releases/tag/v${version}";
    description = "Nest Protect integration for Home Assistant";
    homepage = "https://github.com/iMicknl/ha-nest-protect";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
