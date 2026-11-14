{
  lib,
  kernel,
  rtl8189es,
  fetchFromGitHub,
}:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "rtl8189fs";
  version = "0-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "13bbdbc750bfaa37ff47dff063edcc857fad0584";
    hash = "sha256-la8g/5mCkAMiwmfX63ZhrGa+TAmWeAnbICARaDLurLY=";
  };

  meta = {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ puffnfresh ];
  };
})
