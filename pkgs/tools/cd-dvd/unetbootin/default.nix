{ stdenv, fetchFromGitHub, makeWrapper, qt4, utillinux, coreutils, which, qmake4Hook
, p7zip, mtools, syslinux }:

stdenv.mkDerivation rec {
  name = "unetbootin-${version}";
  version = "655";

  src = fetchFromGitHub {
    owner  = "unetbootin";
    repo   = "unetbootin";
    rev    = version;
    sha256 = "1gis75vy172k7lgh8bwgap74s259y9x1wg3rkqhhqncl2vv0w1py";
  };

  sourceRoot = "${name}-src/src/unetbootin";

  buildInputs = [ qt4 ];
  nativeBuildInputs = [ makeWrapper qmake4Hook ];
  enableParallelBuilding = true;

  # Lots of nice hard-coded paths...
  postPatch = ''
    substituteInPlace unetbootin.cpp \
      --replace /bin/df             ${coreutils}/bin/df \
      --replace /sbin/blkid         ${utillinux}/sbin/blkid \
      --replace /sbin/fdisk         ${utillinux}/sbin/fdisk \
      --replace /sbin/sfdisk        ${utillinux}/sbin/sfdisk \
      --replace /usr/bin/syslinux   ${syslinux}/bin/syslinux \
      --replace /usr/bin/extlinux   ${syslinux}/sbin/extlinux \
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
      --prefix PATH : ${stdenv.lib.makeBinPath [ mtools p7zip which ]} \
      --set QT_X11_NO_MITSHM 1
  '';

  meta = with stdenv.lib; {
    homepage    = http://unetbootin.sourceforge.net/;
    description = "A tool to create bootable live USB drives from ISO images";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ebzzry ];
  };
}
