{stdenv, fetchurl, unzip}:

# We should enable this check once we have the cross target system information
# assert stdenv.system == "armv5tel-linux" || crossConfig == "armv5tel-linux";

# All this file is made for the Marvell Sheevaplug
   
stdenv.mkDerivation {
  name = "uboot-sheevaplug-3.4.27";
   
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-1.1.4.tar.bz2";
    sha256 = "19vp4rlikz7h72pqsjhgz7nmgjy4c6vabvxkw67wni70vy5ddy8s";
  };

  srcAddon = fetchurl {
    url = "http://www.plugcomputer.org/405/us/plug-basic/uboot/u-boot-3.4.27.zip";
    sha256 = "1wqxznpdb6d2kx58gral4q0mg5ddxyrv7az8c6v29nr3cd9yrfsg";
  };

  postUnpack = ''
    mv u-boot-1.1.4 u-boot-3.4.27
    unzip -o $srcAddon
    sourceRoot=u-boot-3.4.27
  '';

  patches = [ ./gas220.patch ];

  # Remove the cross compiler prefix, and add reiserfs support
  configurePhase = ''
    make mrproper
    make rd88f6281Sheevaplug_config NBOOT=1 LE=1
    sed -i /CROSS_COMPILE/d include/config.mk
  '';

  buildPhase = ''
    unset src
    if test -z "$crossConfig"; then
        make clean all
    else
        make clean all ARCH=arm CROSS_COMPILE=$crossConfig-
    fi
  '';

  nativeBuildInputs = [ unzip ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp u-boot-rd88f6281Sheevaplug_400db_nand.bin $out
    cp u-boot u-boot.map $out

    mkdir -p $out/bin
    cp tools/{envcrc,mkimage} $out/bin
  '';
}
