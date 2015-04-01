{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "makebootfat-1.4";

  src = fetchurl {
    url = "mirror://sourceforge/advancemame/${name}.tar.gz";
    sha256 = "0v0g1xax0y6hmw2x10nfhchp9n7vqyvgc33gcxqax8jdq2pxm1q2";
  };

  meta = with stdenv.lib; {
    description = "Create bootable USB disks using the FAT filesystem and syslinux";
    homepage = "http://advancemame.sourceforge.net/boot-readme.html";
    license = licenses.gpl2;
    maintainers = [ maintainers.emery ];
    platforms = platforms.linux;
  };
}
