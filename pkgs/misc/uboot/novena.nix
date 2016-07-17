{stdenv, fetchurl, unzip}:

# We should enable this check once we have the cross target system information
# assert stdenv.system == "armv5tel-linux" || crossConfig == "armv5tel-linux";

let
  version = "2014.10.r8-novena";
in stdenv.mkDerivation {
  name = "uboot-${version}";

  src = fetchurl {
    url = "https://api.github.com/repos/xobs/u-boot-novena/tarball/v${version}";
    name = "u-boot-novena-${version}.tar.gz";
    sha256 = "1146gml64wrsshv7sr8ar5jp8np12h826f70p0b4k1vzil6jf1s4";
  };

  configurePhase = ''
    cp include/linux/compiler-gcc{4,5}.h
    make novena_config
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
    cp u-boot.img $out/u-boot.img
    cp SPL $out/u-boot.spl

    mkdir -p $out/bin
    cp tools/{mkenvimage,dumpimage,mkimage} $out/bin
  '';
}
