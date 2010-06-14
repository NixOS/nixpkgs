{stdenv, fetchurl, perl, bison, mktemp, linuxHeaders, linuxHeadersCross}:

assert stdenv.isLinux;

let
  version = "1.5.15";
  baseMakeFlags = ["V=1" "prefix=$out" "SHLIBDIR=$out/lib"];
in

stdenv.mkDerivation {
  name = "klibc-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/klibc-${version}.tar.bz2";
    sha256 = "1x401wmjca6zkyikf9xz45b3wb1hnj0m2s9in1sg6xdhi3pk8lwb";
  };
  
  makeFlags = baseMakeFlags;

  inherit linuxHeaders;

  crossAttrs = {
    name = "klibc-1.5.17";
    src = fetchurl {
      url = "mirror://kernel/linux/libs/klibc/Testing/klibc-1.5.17.tar.bz2";
      sha256 = "1jmiszf9pdlzj9f72nkv50d7aqrzz12hrmw792xnd2lmn5nrfyx6";
    };

    makeFlags = baseMakeFlags ++ [ "CROSS_COMPILE=${stdenv.cross.config}-"
        "KLIBCARCH=${stdenv.cross.arch}" ];

    patchPhase = ''
      sed -i /KLIBCKERNELSRC/d scripts/Kbuild.install
    '';

    linuxHeaders = linuxHeadersCross;
  };
  
  # The AEABI option concerns only arm systems, and does not affect the build for
  # other systems.
  preBuild = ''
    sed -i /CONFIG_AEABI/d defconfig
    echo "CONFIG_AEABI=y" >> defconfig
    makeFlags=$(eval "echo $makeFlags")

    mkdir linux
    cp -prsd $linuxHeaders/include linux/
    chmod -R u+w linux/include/
  ''; # */
  
  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/
    cp usr/dash/sh $dir/
  '';
  
  buildNativeInputs = [ perl bison mktemp ];
}
