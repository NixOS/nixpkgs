{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "Lash-L";
  domain = "roborock_custom_map";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "RoborockCustomMap";
    tag = version;
    hash = "sha256-ZKaUTUTN0tTW8bks0TYixfmbEa7A7ERdJ+xZ365HEbU=";
  };

  meta = {
    description = "This allows you to use the core Roborock integration with the Xiaomi Map Card";
    homepage = "https://github.com/Lash-L/RoborockCustomMap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
