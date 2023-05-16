{ writeShellApplication
, klipper
, python3
, gnumake
<<<<<<< HEAD
=======
, pkgsCross
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}: writeShellApplication {
  name = "klipper-genconf";
  runtimeInputs = [
    python3
<<<<<<< HEAD
=======
    pkgsCross.avr.stdenv.cc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gnumake
  ];
  text = ''
    CURRENT_DIR=$(pwd)
    TMP=$(mktemp -d)
    make -C ${klipper.src} OUT="$TMP" KCONFIG_CONFIG="$CURRENT_DIR/config" menuconfig
    rm -rf "$TMP" config.old
    printf "\nYour firmware configuration for klipper:\n\n"
    cat config
  '';
}
