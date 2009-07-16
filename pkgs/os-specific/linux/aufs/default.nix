{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "aufs-snap-2.6.30-${kernel.version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/linux-modules-extra-2.6/linux-modules-extra-2.6_2.6.30-1.tar.gz";
    sha256 = "19llmha4ynvnk5jgvf9iabl1kk7qhliyq7s3y2a9dna3kbkpw2vw";
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
