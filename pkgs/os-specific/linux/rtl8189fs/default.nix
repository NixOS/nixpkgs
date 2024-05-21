{ lib, kernel, rtl8189es, fetchFromGitHub, fetchpatch }:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "rtl8189fs-${kernel.version}-${version}";
  version = "2024-01-22";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "5d523593f41c0b8d723c6aa86b217ee1d0965786";
    sha256 = "sha256-pziaUM6XfF4Tt9yfWUnLUiTw+sw6uZrr1HcaXdRQ31E=";
  };

  meta = with lib; {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
})
