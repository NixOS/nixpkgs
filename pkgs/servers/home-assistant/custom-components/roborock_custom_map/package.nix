{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "Lash-L";
  domain = "roborock_custom_map";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "RoborockCustomMap";
    tag = version;
    hash = "sha256-zAKGlhil6UE9Wlz3KhUg2XFIGblj/2jGtxVXP/+ryvw=";
  };

  meta = {
    description = "This allows you to use the core Roborock integration with the Xiaomi Map Card";
    homepage = "https://github.com/Lash-L/RoborockCustomMap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
