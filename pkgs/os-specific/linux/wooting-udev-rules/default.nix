{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "wooting-udev-rules";
<<<<<<< HEAD
  version = "unstable-2023-03-31";

  # Source: https://help.wooting.io/en/article/wootility-configuring-device-access-for-wootility-under-linux-udev-rules-r6lb2o/
=======
  version = "20210525";

  # Source: https://wooting.helpscoutdocs.com/article/68-wootility-configuring-device-access-for-wootility-under-linux-udev-rules
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = [ ./wooting.rules ];

  dontUnpack = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-wooting.rules
  '';

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://help.wooting.io/en/article/wootility-configuring-device-access-for-wootility-under-linux-udev-rules-r6lb2o/";
=======
    homepage = "https://wooting.helpscoutdocs.com/article/34-linux-udev-rules";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "udev rules that give NixOS permission to communicate with Wooting keyboards";
    platforms = platforms.linux;
    license = "unknown";
    maintainers = with maintainers; [ davidtwco ];
  };
}
