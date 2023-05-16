{ lib, kernel, rtl8189es, fetchFromGitHub, fetchpatch }:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "rtl8189fs-${kernel.version}-${version}";
<<<<<<< HEAD
  version = "2023-03-27";
=======
  version = "2022-10-30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
<<<<<<< HEAD
    rev = "c223a25b1000d64432eca4201a8f012414dfc7ce";
    sha256 = "sha256-5b5IshLbWxvmzcKy/xLsqKa3kZpwDQXTQtjqZLHyOCo=";
=======
    rev = "e58bd86c9d9408c648b1246a0dd76b16856ec172";
    sha256 = "sha256-KKly72N6ACBTB4CSBM6Q/S1wGMTg5NZA3QYslYPNUr8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
})
