{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "aufs-20080508";

  src = fetchurl {
    url = http://nixos.org/tarballs/aufs-20080508.tar.bz2;
    sha256 = "1b7y6klk2fc6hf8w2la4k3yvxdvjibsnhv7d6mb12a7h13msjci6";
  };

  patches = [
    (fetchurl {
      url = http://www.mail-archive.com/aufs-users@lists.sourceforge.net/msg01091/04_sec_perm.dpatch;
      sha256 = "0b51dpks4d5qgysrakv2c1v076d9hc8ln2cbh012zi75b45gn4ir";
    })
  ];

  buildPhase = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    kernelBuild=$(echo ${kernel}/lib/modules/$kernelVersion/source)
    tar xvfj ${kernel.src}
    kernelSource=$(echo $(pwd)/linux-*)
    cp -prd $kernelBuild/* $kernelSource
  
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

  meta = {
    description = "Another Unionfs implementation for Linux";
    homepage = http://aufs.sourceforge.net/;
  };
}
