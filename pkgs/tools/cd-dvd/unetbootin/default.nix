{ stdenv, fetchurl, makeWrapper, qt4, utillinux, coreutils, which, p7zip, mtools, syslinux }:

let version = "608"; in

stdenv.mkDerivation {
  name = "unetbootin-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/unetbootin/UNetbootin/${version}/unetbootin-source-${version}.tar.gz";
    sha256 = "1010ccdrblsjr5zid6wl3c3b75ld37lrr1a1xc6dlrhz1gvcb6ff";
  };

  sourceRoot = ".";

  buildInputs = [ makeWrapper qt4 ];

  # Lots of nice hard-coded paths...
  postUnpack =
    ''
      substituteInPlace unetbootin.cpp \
          --replace /sbin/fdisk ${utillinux}/sbin/fdisk \
          --replace /sbin/sfdisk ${utillinux}/sbin/sfdisk \
          --replace /sbin/blkid ${utillinux}/sbin/blkid \
          --replace /bin/df ${coreutils}/bin/df \
          --replace /usr/bin/syslinux ${syslinux}/bin/syslinux \
          --replace /usr/bin/extlinux ${syslinux}/sbin/extlinux \
          --replace /usr/share/syslinux ${syslinux}/share/syslinux
      substituteInPlace main.cpp \
          --replace /usr/share/unetbootin $out/share/unetbootin
      substituteInPlace unetbootin.desktop \
          --replace /usr/bin $out/bin
    '';

  buildPhase =
    ''
      lupdate unetbootin.pro
      lrelease unetbootin.pro
      qmake
      make
    '';

  installPhase =
    ''
      mkdir -p $out/bin
      cp unetbootin $out/bin

      mkdir -p $out/share/unetbootin
      cp unetbootin_*.qm  $out/share/unetbootin

      mkdir -p $out/share/applications
      cp unetbootin.desktop $out/share/applications

      wrapProgram $out/bin/unetbootin \
          --prefix PATH : ${which}/bin:${p7zip}/bin:${mtools}/bin
    '';

  meta = {
    homepage = http://unetbootin.sourceforge.net/;
    description = "A tool to create bootable live USB drives from ISO images";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
