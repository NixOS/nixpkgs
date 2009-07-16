{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "aufs-20090716-${kernel.version}";

  src = fetchgit {
    url = http://git.c3sl.ufpr.br/pub/scm/aufs/aufs2-standalone.git;
    md5 = "3945dd258f7c3baede49893b42073c42";
    rev = "c5a75e75865debfc781b4cc2ddd2bf7aae3736e7";
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
  ];

  meta = {
    description = "Another Unionfs implementation for Linux";
    homepage = http://aufs.sourceforge.net/;
  };
}
