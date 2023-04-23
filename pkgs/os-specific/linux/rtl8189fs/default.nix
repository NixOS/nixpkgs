{ lib, kernel, rtl8189es, fetchFromGitHub, fetchpatch }:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "rtl8189fs-${kernel.version}-${version}";
  version = "2022-10-30";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "e58bd86c9d9408c648b1246a0dd76b16856ec172";
    sha256 = "sha256-KKly72N6ACBTB4CSBM6Q/S1wGMTg5NZA3QYslYPNUr8=";
  };

  meta = with lib; {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
})
