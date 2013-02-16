{ stdenv, fetchurl, openssl, zlib, libjpeg, xorg, coreutils }:

stdenv.mkDerivation rec {
  name = "x11vnc-0.9.13";

  src = fetchurl {
    url = "mirror://sourceforge/libvncserver/${name}.tar.gz";
    sha256 = "0fzib5xb1vbs8kdprr4z94v0fshj2c5hhaz69llaarwnc8p9z0pn";
  };

  buildInputs =
    [ xorg.libXfixes xorg.fixesproto openssl xorg.libXdamage
      xorg.damageproto zlib xorg.libX11 xorg.xproto libjpeg
      xorg.libXtst xorg.libXinerama xorg.xineramaproto xorg.libXrandr
      xorg.randrproto xorg.libXext xorg.xextproto xorg.inputproto
      xorg.recordproto xorg.libXi xorg.libXrender xorg.renderproto
    ];

  preConfigure = ''
    configureFlags="--mandir=$out/share/man"

    substituteInPlace x11vnc/unixpw.c \
        --replace '"/bin/su"' '"/var/setuid-wrappers/su"' \
        --replace '"/bin/true"' '"${coreutils}/bin/true"'
        
    substituteInPlace x11vnc/ssltools.h \
        --replace /bin/su /var/setuid-wrappers/su \
        --replace xdpyinfo ${xorg.xdpyinfo}/bin/xdpyinfo
  '';

  meta = {
    description = "A VNC server connected to a real X11 screen";
    homepage = http://www.karlrunge.com/x11vnc/;
  };
}
