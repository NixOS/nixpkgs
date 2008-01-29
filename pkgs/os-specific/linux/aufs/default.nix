{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "aufs-20080128";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/aufs-20080128.tar.bz2;
    sha256 = "0732zp6wfss09x9d6n0a3v65rifn739m9nffi5d3952vglg4va6l";
  };

  buildPhase = ''
    mkdir kernelsrc
    tar xvf ${kernel.src} -C kernelsrc
  
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    substituteInPlace fs/aufs/Makefile --replace srctree srctree2
    make KDIR=${kernel}/lib/modules/$kernelVersion/build srctree2=$(pwd)/kernelsrc/* -f local.mk
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
    description = "Another Unionfs implementation for Linux";
    homepage = http://aufs.sourceforge.net/;
  };
}
