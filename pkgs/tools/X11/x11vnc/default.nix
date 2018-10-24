{ stdenv, fetchFromGitHub,
  openssl, zlib, libjpeg, xorg, coreutils, libvncserver,
  autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "x11vnc-${version}";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "x11vnc";
    rev = version;
    sha256 = "1a1b65k1hsy4nhg2sx1yrpaz3vx6s7rmrx8nwygpaam8wpdlkh8p";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs =
    [ xorg.libXfixes xorg.fixesproto openssl xorg.libXdamage
      xorg.damageproto zlib xorg.libX11 xorg.xproto libjpeg
      xorg.libXtst xorg.libXinerama xorg.xineramaproto xorg.libXrandr
      xorg.randrproto xorg.libXext xorg.xextproto xorg.inputproto
      xorg.recordproto xorg.libXi xorg.libXrender xorg.renderproto
      libvncserver
    ];

  postPatch = ''
    substituteInPlace src/unixpw.c \
        --replace '"/bin/su"' '"/run/wrappers/bin/su"' \
        --replace '"/bin/true"' '"${coreutils}/bin/true"'

    sed -i -e '/#!\/bin\/sh/a"PATH=${xorg.xdpyinfo}\/bin:${xorg.xauth}\/bin:$PATH\\n"' -e 's|/bin/su|/run/wrappers/bin/su|g' src/ssltools.h

    # Xdummy script is currently broken, so we avoid building it. This removes everything Xdummy-related from the affected Makefile
    sed -i -e '/^\tXdummy.c\ \\$/,$d' -e 's/\tx11vnc_loop\ \\/\tx11vnc_loop/' misc/Makefile.am
  '';

  preConfigure = ''
    configureFlags="--mandir=$out/share/man"
  '';

  meta = with stdenv.lib; {
    description = "A VNC server connected to a real X11 screen";
    homepage = https://github.com/LibVNC/x11vnc/;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
