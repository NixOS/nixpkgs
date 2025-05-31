{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent rec {
  owner = "iMicknl";
  domain = "nest_protect";
  version = "0.4.2b0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-nest-protect";
    tag = "v${version}";
    hash = "sha256-CQVAvx7iRCRHw8YXDmsWaF6fhddx3OfSLjq218+ob6I=";
  };

  # AttributeError: 'async_generator' object has no attribute 'data'
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/iMicknl/ha-nest-protect/releases/tag/v${version}";
    description = "Nest Protect integration for Home Assistant";
    homepage = "https://github.com/iMicknl/ha-nest-protect";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
