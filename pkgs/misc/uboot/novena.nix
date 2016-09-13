{stdenv, fetchurl, unzip}:

# We should enable this check once we have the cross target system information
# assert stdenv.system == "armv5tel-linux" || crossConfig == "armv5tel-linux";

let
  version = "v2014.10.r8-novena";
in stdenv.mkDerivation {
  name = "uboot-${version}";

  src = fetchurl {
    url = "https://github.com/xobs/u-boot-novena/archive/${version}.tar.gz";
    name = "u-boot-novena-${version}.tar.gz";
    sha256 = "0icdplngdqdk08j0xxmz9zzgnx4h2wg3kiniwx1cpjvm7ynjxslq";
  };

  configurePhase = ''
    make novena_config
  '';

  patchPhase = ''
    cp include/linux/compiler-gcc{4,5}.h
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
