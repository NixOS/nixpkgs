{ stdenv, fetchurl, makeWrapper, qt4, utillinux, coreutils, which, qmake4Hook
, p7zip, mtools, syslinux }:

stdenv.mkDerivation rec {
  name = "unetbootin-${version}";
  version = "613";

  src = fetchurl {
    url = "mirror://sourceforge/unetbootin/UNetbootin/${version}/unetbootin-source-${version}.tar.gz";
    sha256 = "1f389z5lqimp4hlxm6zlrh1ja474r6ivzb9r43i9bvf0z1n21f0q";
  };

  sourceRoot = ".";

  buildInputs = [ makeWrapper qt4 qmake4Hook ];

  # Lots of nice hard-coded paths...
  postUnpack = ''
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

  preConfigure = ''
    lupdate unetbootin.pro
    lrelease unetbootin.pro
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp unetbootin $out/bin

    mkdir -p $out/share/unetbootin
    cp unetbootin_*.qm  $out/share/unetbootin

    mkdir -p $out/share/applications
    cp unetbootin.desktop $out/share/applications

    wrapProgram $out/bin/unetbootin \
      --prefix PATH : ${stdenv.lib.makeBinPath [ which p7zip mtools ]}
  '';

  meta = with stdenv.lib; {
    homepage = http://unetbootin.sourceforge.net/;
    description = "A tool to create bootable live USB drives from ISO images";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ebzzry ];
  };
}
