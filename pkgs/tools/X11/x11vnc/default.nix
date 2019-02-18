{ stdenv, fetchFromGitHub,
  openssl, zlib, libjpeg, xorg, coreutils, libvncserver,
  autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "x11vnc-${version}";
  version = "0.9.16";

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "x11vnc";
    rev = version;
    sha256 = "1g652mmi79pfq4p5p7spaswa164rpzjhc5rn2phy5pm71lm0vib1";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs =
    [ xorg.libXfixes xorg.xorgproto openssl xorg.libXdamage
      zlib xorg.libX11 libjpeg
      xorg.libXtst xorg.libXinerama xorg.libXrandr
      xorg.libXext
      xorg.libXi xorg.libXrender
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
