{ stdenv, fetchFromGitHub, makeWrapper, qt4, utillinux, coreutils, which, qmake4Hook
, p7zip, mtools, syslinux }:

stdenv.mkDerivation rec {
  pname = "unetbootin";
  version = "677";

  src = fetchFromGitHub {
    owner  = "unetbootin";
    repo   = "unetbootin";
    rev    = version;
    sha256 = "1mk6179r2lz2d0pvln1anvf5p4l7vfrnnnlhgyx2dlx6pfacsspy";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */src/unetbootin)
  '';

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
    runHook preInstall

    install -Dm755 -t $out/bin                unetbootin
    install -Dm644 -t $out/share/unetbootin   unetbootin_*.qm
    install -Dm644 -t $out/share/applications unetbootin.desktop

    wrapProgram $out/bin/unetbootin \
      --prefix PATH : ${stdenv.lib.makeBinPath [ mtools p7zip which ]} \
      --set QT_X11_NO_MITSHM 1

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage    = http://unetbootin.sourceforge.net/;
    description = "A tool to create bootable live USB drives from ISO images";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ebzzry ];
  };
}
