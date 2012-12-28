{stdenv, fetchurl, unzip}:

let
  platform = stdenv.platform;
  configureFun = ubootConfig :
    ''
      make mrproper
      make ${ubootConfig} NBOOT=1 LE=1
    '';

  buildFun = kernelArch :
    ''
      unset src
      if test -z "$crossConfig"; then
          make clean all
      else
          make clean all ARCH=${kernelArch} CROSS_COMPILE=$crossConfig-
      fi
    '';
in

stdenv.mkDerivation {
  name = "uboot-2009.11";
   
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-2009.11.tar.bz2";
    sha256 = "1rld7q3ww89si84g80hqskd1z995lni5r5xc4d4322n99wqiarh6";
  };

  nativeBuildInputs = [ unzip ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp u-boot.bin $out
    cp u-boot u-boot.map $out

    mkdir -p $out/bin
    cp tools/{envcrc,mkimage} $out/bin
  '';

  configurePhase =
    assert platform ? uboot && platform.uboot != null;
    assert (platform ? ubootConfig);
      configureFun platform.ubootConfig;

  buildPhase = assert (platform ? kernelArch);
    buildFun platform.kernelArch;

  crossAttrs = let
      cp = stdenv.cross.platform;
    in
    assert cp ? uboot && cp.uboot != null;
    {
      configurePhase = assert (cp ? ubootConfig);
        configureFun cp.ubootConfig;

      buildPhase = assert (cp ? kernelArch);
        buildFun cp.kernelArch;
    };
}
