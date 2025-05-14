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
  version = "3.18.3";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "YandexStation";
    tag = "v${version}";
    hash = "sha256-l8DsL8g6K8/SjCIk7rjfQSk4iRsKBoGgzJpy7UhxQ7o=";
  };

  dependencies = [
    zeroconf
  ];

  nativeCheckInputs = [
    home-assistant
    pytestCheckHook
  ] ++ (home-assistant.getPackages "stream" home-assistant.python.pkgs);

  meta = {
    description = "Controlling Yandex.Station and other smart home devices with Alice from Home Assistant";
    homepage = "https://github.com/AlexxIT/YandexStation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
