{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  neohubapi,
}:

buildHomeAssistantComponent rec {
  owner = "MindrustUK";
  domain = "heatmiserneo";
  version = "3.2.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "Heatmiser-for-home-assistant";
    tag = "v${version}";
    hash = "sha256-74VELIDrZOLnQELej0iwnXQIqZAdr0O5IrWWgOBW8zc=";
  };

  dependencies = [
    neohubapi
  ];

  meta = {
    changelog = "https://github.com/MindrustUK/Heatmiser-for-home-assistant/releases/tag/v${version}/docs/changelog.md";
    description = "An integration for Home Assistant to add support for Heatmiser's Neo-Hub and 'Neo' range of products.";
    homepage = "https://github.com/MindrustUK/Heatmiser-for-home-assistant";
    maintainers = with lib.maintainers; [ graham33 ];
    license = with lib.licenses; [
      asl20
      gpl2Only
    ];
  };
}
