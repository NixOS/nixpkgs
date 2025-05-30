{
  lib,
  kernel,
  rtl8189es,
  fetchFromGitHub,
}:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "rtl8189fs-${kernel.version}-${version}";
  version = "2025-05-04";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "06e89edce6817616d963414825dccf87094a7e54";
    sha256 = "sha256-W+gBpK17PmF8BdmBoUHPX7hZoSNOyGe3W1NypR8bc6A=";
  };

  meta = with lib; {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
})
