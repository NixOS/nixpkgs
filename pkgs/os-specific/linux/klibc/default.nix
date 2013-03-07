{ stdenv, fetchurl, perl, bison, mktemp, linuxHeaders, linuxHeadersCross, kernel ? null }:

assert stdenv.isLinux;

let
  version = "1.5.24";
  baseMakeFlags = ["V=1" "prefix=$out" "SHLIBDIR=$out/lib"];
in

stdenv.mkDerivation {
  name = "klibc-${version}${stdenv.lib.optionalString (kernel != null) "-${kernel.version}"}";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/1.5/klibc-${version}.tar.bz2";
    sha256 = "18lm32dlj9k2ky9wwk274zmc3jndgrb41b6qm82g3lza6wlw3yki";
  };

  # Trick to make this build on nix. It expects to have the kernel sources
  # instead of only the linux kernel headers.
  # So it cannot run the 'make headers_install' it wants to run.
  # We don't install the headers, so klibc will not be useful as libc, but
  # usually in nixpkgs we only use the userspace tools comming with klibc.
  prePatch = stdenv.lib.optionalString (kernel == null) ''
    sed -i -e /headers_install/d scripts/Kbuild.install
  '';
  
  makeFlags = baseMakeFlags;

  inherit linuxHeaders;

  crossAttrs = {
    makeFlags = baseMakeFlags ++ [ "CROSS_COMPILE=${stdenv.cross.config}-"
        "KLIBCARCH=${stdenv.cross.arch}" ];

    patchPhase = ''
      sed -i 's/-fno-pic -mno-abicalls/& -mabi=32/' usr/klibc/arch/mips/MCONFIG
      sed -i /KLIBCKERNELSRC/d scripts/Kbuild.install
      # Wrong check for __mips64 in klibc
      sed -i s/__mips64__/__mips64/ usr/include/fcntl.h
    '';

    linuxHeaders = linuxHeadersCross;
  };
  
  # The AEABI option concerns only arm systems, and does not affect the build for
  # other systems.
  preBuild = ''
    sed -i /CONFIG_AEABI/d defconfig
    echo "CONFIG_AEABI=y" >> defconfig
    makeFlags=$(eval "echo $makeFlags")

  '' + (if kernel == null then ''
    mkdir linux
    cp -prsd $linuxHeaders/include linux/
    chmod -R u+w linux/include/
  '' else ''
    tar xvf ${kernel.src}
    mv linux* linux
    cd linux
    ln -sv ${kernel}/config .config
    make prepare
    cd ..
  '');
  
  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/
    cp usr/dash/sh $dir/
  '';
  
  nativeBuildInputs = [ perl bison mktemp ];
}
