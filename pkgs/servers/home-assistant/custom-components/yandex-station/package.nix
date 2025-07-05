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
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "YandexStation";
    tag = "v${version}";
    hash = "sha256-O+LHD9wKnXaNX/aVrt5lOuuqi1ymF+YqEJP+24NVBhw=";
  };

  dependencies = [
    zeroconf
  ];

  pytestFlagsArray = [
    # this test seems to be broken
    "--deselect=tests/test_local.py::test_track"
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
