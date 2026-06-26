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
  version = "2025-09-26";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "876e627a5b6a8021700391b4249a4a31edfebe5c";
    hash = "sha256-3v40I09TDGWdpllS3WfshPkXbT5Q2pWMTalHLUlU3lU=";
  };

  meta = {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ puffnfresh ];
  };
})
