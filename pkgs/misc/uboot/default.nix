{stdenv, fetchurl, unzip, platform}:

# This does not cover the case for cross-building, but we need some filtering
# for the normal stdenv, in order to build the nixpkgs tarball
assert (stdenv.system != "i686-linux" && stdenv.system != "x86_64-linux")
  || (stdenv ? cross);

stdenv.mkDerivation {
  name = "uboot-2009.11";
   
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-2009.11.tar.bz2";
    sha256 = "1rld7q3ww89si84g80hqskd1z995lni5r5xc4d4322n99wqiarh6";
  };

  # patches = [ ./gas220.patch ];

  # Remove the cross compiler prefix, and add reiserfs support
  configurePhase = assert (platform ? ubootConfig);
    ''
      make mrproper
      make ${platform.ubootConfig} NBOOT=1 LE=1
      sed -i /CROSS_COMPILE/d include/config.mk
    '';

  buildPhase = assert (platform ? kernelArch);
    ''
      unset src
      if test -z "$crossConfig"; then
          make clean all
      else
          make clean all ARCH=${platform.kernelArch} CROSS_COMPILE=$crossConfig-
      fi
    '';

  buildNativeInputs = [ unzip ];

  dontStrip = true;
  NIX_STRIP_DEBUG = false;

  installPhase = ''
    ensureDir $out
    cp u-boot.bin $out
    cp u-boot u-boot.map $out

    ensureDir $out/bin
    cp tools/{envcrc,mkimage} $out/bin
  '';
}
