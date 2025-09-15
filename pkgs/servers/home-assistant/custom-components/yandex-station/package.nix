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
  version = "3.20.0";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "YandexStation";
    tag = "v${version}";
    hash = "sha256-dGMq/uJBr30K9J4C5rFbX99ykf3WttPMLEHf6674THk=";
  };

  dependencies = [
    zeroconf
  ];

  disabledTests = [
    # 'µg/m³' vs 'μg/m³'
    "test_sensor_qingping"
  ];

  disabledTestPaths = [
    # this test seems to be broken
    "tests/test_local.py::test_track"
  ];
  nativeCheckInputs = [
    home-assistant
    pytestCheckHook
  ]
  ++ (home-assistant.getPackages "stream" home-assistant.python.pkgs);

  meta = {
    changelog = "https://github.com/AlexxIT/YandexStation/releases/tag/${src.tag}";
    description = "Controlling Yandex.Station and other smart home devices with Alice from Home Assistant";
    homepage = "https://github.com/AlexxIT/YandexStation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
