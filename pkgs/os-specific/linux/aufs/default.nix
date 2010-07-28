{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "aufs-20090414-${kernel.version}";

  src = fetchurl {
    url = http://nixos.org/tarballs/aufs-20090414.tar.bz2;
    sha256 = "1jhf3kccx0m84frlgx2d0ysn1c4272dgci59dsk7vsfrf7yik526";
  };

  buildPhase = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    kernelBuild=$(echo ${kernel}/lib/modules/$kernelVersion/source)
    tar xvfj ${kernel.src}
    kernelSource=$(echo $(pwd)/linux-*)
    cp -prd $kernelBuild/* $kernelSource

    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$PWD/include"
  
    make KDIR=$kernelSource -f local.mk
  '';

  installPhase = ''
    ensureDir $out/bin
    cp util/aulchown $out/bin

    ensureDir $out/share/man/man5
    cp util/aufs.5 $out/share/man/man5

    ensureDir $out/lib/modules/$kernelVersion/misc
    cp aufs.ko $out/lib/modules/$kernelVersion/misc
  '';

  patches = [
    # Debian patch to build AUFS on 2.6.29+
    ./debian-2.6.29.diff
  ];

  meta = {
    description = "Another Unionfs implementation for Linux";
    homepage = http://aufs.sourceforge.net/;
  };
}
