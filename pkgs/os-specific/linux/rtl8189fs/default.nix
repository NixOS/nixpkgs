{ lib, kernel, rtl8189es, fetchFromGitHub, fetchpatch }:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "rtl8189fs-${kernel.version}-${version}";
  version = "2023-03-27";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "c223a25b1000d64432eca4201a8f012414dfc7ce";
    sha256 = "sha256-5b5IshLbWxvmzcKy/xLsqKa3kZpwDQXTQtjqZLHyOCo=";
  };

  meta = with lib; {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
})
