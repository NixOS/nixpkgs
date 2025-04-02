{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  zeroconf,
}:
buildHomeAssistantComponent rec {
  owner = "AlexxIT";
  domain = "yandex_station";
  version = "3.18.3";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "YandexStation";
    rev = "v${version}";
    hash = "sha256-l8DsL8g6K8/SjCIk7rjfQSk4iRsKBoGgzJpy7UhxQ7o=";
  };
  dependencies = [
    zeroconf
  ];
  meta = {
    description = "Управление Яндекс.Станцией и другими устройствами умного дома с Алисой из Home Assistant";
    homepage = "https://github.com/AlexxIT/YandexStation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ferrine ];
    platforms = lib.platforms.all;
  };
}
