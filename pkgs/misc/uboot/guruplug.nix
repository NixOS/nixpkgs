{stdenv, fetchgit, unzip}:

# Marvell's branch of U-Boot for the GuruPlug.

let
  # Aug 2010 revision of the `testing' branch of Marvell's U-Boot repository.
  # See
  # <http://www.openplug.org/plugwiki/index.php/Re-building_the_kernel_and_U-Boot>
  # for details.
  rev = "f106056095049c2c748c2a2797e5353295240e04";
in
stdenv.mkDerivation {
  name = "uboot-guruplug-0.0-pre-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "git://git.denx.de/u-boot-marvell.git";
    sha256 = "18gwyj16vml7aja9cyan51jwfcysy4cs062z7wmgdc0l9bha6iw7";
    inherit rev;
  };

  patches =
    [ ./guruplug-file-systems.patch ./guruplug-usb-msd-multi-lun.patch ];

  enableParallelBuilding = true;

  # Remove the cross compiler prefix.
  configurePhase = ''
    make mrproper
    make guruplug_config
    sed -i /CROSS_COMPILE/d include/config.mk
  '';

  buildPhase = ''
    unset src
    if test -z "$crossConfig"; then
        make all u-boot.kwb
    else
        make all u-boot.kwb ARCH=arm CROSS_COMPILE=$crossConfig-
    fi
  '';

  nativeBuildInputs = [ unzip ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -v u-boot u-boot.{kwb,map} $out

    mkdir -p $out/bin
    cp tools/{envcrc,mkimage} $out/bin
  '';
}
