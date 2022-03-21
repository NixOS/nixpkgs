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
  ];
  text = ''
    CURRENT_DIR=$(pwd)
    TMP=$(mktemp -d)
    pushd ${klipper.src}
    ${gnumake}/bin/make OUT="$TMP" KCONFIG_CONFIG="$CURRENT_DIR/config" menuconfig
    popd
    rm -rf "$TMP" config.old
    printf "\nYour firmware configuration for klipper:\n\n"
    cat config
  '';
}
