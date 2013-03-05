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
  name = "uboot-2012.07";
   
  src = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-2012.07.tar.bz2";
    sha256 = "15nli6h9a127ldizsck3g4ysy5j4m910wawspgpadz4vjyk213p0";
  };

  buildNativeInputs = [ unzip ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp u-boot.bin $out
    cp u-boot u-boot.map $out

    mkdir -p $out/bin
    cp tools/{envcrc,mkimage} $out/bin
  '';

  # They have 'errno.h' included by a "-idirafter". As the gcc
  # wrappers add the glibc include as "-idirafter", the only way
  # we can make the glibc take priority is to -include errno.h.
  postPatch = if stdenv ? glibc && stdenv.glibc != null then ''
    sed -i 's,$(HOSTCPPFLAGS),-include ${stdenv.glibc}/include/errno.h $(HOSTCPPFLAGS),' config.mk
  '' else "";

  patches = [ ./sheevaplug-sdio.patch ./sheevaplug-config.patch ];

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
