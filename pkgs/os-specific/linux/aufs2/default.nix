{stdenv, fetchgit, kernel}:

let s = import ./src-for-default.nix; in

stdenv.mkDerivation {
  name = "${s.name}-${kernel.version}";

  src = fetchgit {
    inherit (s) url rev;
    sha256 = s.hash;
  };

  buildPhase = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    kernelBuild=$(echo ${kernel}/lib/modules/$kernelVersion/source)
    tar xvfj ${kernel.src}
    kernelSource=$(echo $(pwd)/linux-*)
    cp -prd $kernelBuild/* $kernelSource

    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$PWD/include"
  
    make KDIR=$kernelSource aufs.ko
  '';

  installPhase = ''
    ensureDir $out/bin
    cp util/aulchown $out/bin

    ensureDir $out/share/man/man5
    cp util/aufs.5 $out/share/man/man5

    ensureDir $out/lib/modules/$kernelVersion/misc
    cp aufs.ko $out/lib/modules/$kernelVersion/misc
  '';

  meta = {
    description = "Another Unionfs implementation for Linux - second generation";
    homepage = http://aufs.sourceforge.net/;
  };
}
