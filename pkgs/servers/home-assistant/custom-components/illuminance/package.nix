{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "pnbruckner";
  domain = "illuminance";
  version = "5.8.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-illuminance";
    tag = version;
    hash = "sha256-3wXoz9yzdhWJo5Un5SdUdk/hYssvaqdGAAuW6+QGbZk=";
  };

  meta = {
    changelog = "https://github.com/pnbruckner/ha-illuminance/releases/tag/${version}";
    description = "Estimate outdoor illuminance from weather data";
    homepage = "https://github.com/pnbruckner/ha-illuminance";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
}
