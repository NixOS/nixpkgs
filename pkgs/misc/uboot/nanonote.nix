{stdenv, fetchurl, fetchgit}:

# We should enable this check once we have the cross target system information
# assert stdenv.system == "armv5tel-linux" || crossConfig == "armv5tel-linux";

# All this file is made for the Marvell Sheevaplug
   
stdenv.mkDerivation {
  name = "uboot-qb-2010.06";
   
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-2010.06.tar.bz2";
    sha256 = "1j0bl8x5i5m1pn62z450gbw30pbrj7sgs3fjp2l2giczv49cn33r";
  };

  srcPatches = fetchgit {
    url = "git://projects.qi-hardware.com/openwrt-xburst.git";
    rev = "3244d5ef9f93802f9b9b6f4405636424abf6fa83";
    sha256 = "0mg87s10hpz41dr1zbd3bcl8i64gwvh3f1nrz8cb8c49099miqla";
  };

  patchPhase = ''
    cp -R $srcPatches/package/uboot-xburst/files/* .
    for a in $srcPatches/package/uboot-xburst/patches/*; do
        patch -p1 < $a
    done
    chmod +w -R *
    sed -i -e 's/console=ttyS0,57600n8//' include/configs/qi_lb60.h
    # Load more than 2MiB for the kernel
    sed -i -e 's/0x200000;bootm/0x400000;bootm/' include/configs/qi_lb60.h
  '';

  # Remove the cross compiler prefix, and add reiserfs support
  configurePhase = ''
    make mrproper
    make qi_lb60_config
    sed -i /CROSS_COMPILE/d include/config.mk
  '';

  buildPhase = ''
    # A variable named 'src' used to affect the build in some uboot...
    unset src
    if test -z "$crossConfig"; then
        make clean all
    else
        make clean all ARCH=mips CROSS_COMPILE=$crossConfig-
    fi
  '';

  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp u-boot-nand.bin $out
    cp u-boot u-boot.map $out

    mkdir -p $out/bin
    cp tools/{envcrc,mkimage} $out/bin
  '';
}
