{ writeShellApplication
, klipper
, python2
, gnumake
, pkgsCross
}: writeShellApplication {
  name = "klipper-genconf";
  runtimeInputs = [
    python2
    pkgsCross.avr.stdenv.cc
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
