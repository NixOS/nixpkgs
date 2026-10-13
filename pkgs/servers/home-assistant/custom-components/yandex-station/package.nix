{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  zeroconf,
  pytestCheckHook,
  home-assistant,

}:
buildHomeAssistantComponent rec {
  owner = "AlexxIT";
  domain = "yandex_station";
  version = "3.22.1";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "YandexStation";
    tag = "v${version}";
    hash = "sha256-EzW+nyFTTjCsx8RBg9c193GAIRJivwrw96keSdVRIX0=";
  };

  dependencies = [
    zeroconf
  ];

  nativeCheckInputs = [
    home-assistant
    pytestCheckHook
  ]
  ++ (home-assistant.getPackages "stream" home-assistant.python3Packages);

  meta = {
    changelog = "https://github.com/AlexxIT/YandexStation/releases/tag/${src.tag}";
    description = "Controlling Yandex.Station and other smart home devices with Alice from Home Assistant";
    homepage = "https://github.com/AlexxIT/YandexStation";
    license = lib.licenses.mit;
  };
}
