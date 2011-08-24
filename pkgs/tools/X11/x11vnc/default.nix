{ stdenv, fetchurl, openssl, zlib, libjpeg, xorg }:

stdenv.mkDerivation rec {
  name = "x11vnc-0.9.12";

  src = fetchurl {
    url = "mirror://sourceforge/libvncserver/${name}.tar.gz";
    sha256 = "60a7cceee2c9a5f1c854340b2bae13f975ac55906237042f81f795b28a154a79";
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
  '';

  meta = {
    description = "A VNC server connected to a real X11 screen";
    homepage = http://www.karlrunge.com/x11vnc/;
  };
}
