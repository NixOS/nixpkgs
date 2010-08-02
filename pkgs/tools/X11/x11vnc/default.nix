{ stdenv, fetchurl, openssl, zlib, libjpeg, xorg }:

stdenv.mkDerivation rec {
  name = "x11vnc-0.9.10";

  src = fetchurl {
    url = "mirror://sourceforge/libvncserver/${name}.tar.gz";
    sha256 = "04g0da04g4iw0qwvn43a8vh2im4wx9rwl1w41acsbdi8b0amhlck";
  };

  buildInputs =
    [ xorg.libXfixes xorg.fixesproto openssl xorg.libXdamage
      xorg.damageproto zlib xorg.libX11 xorg.xproto libjpeg
      xorg.libXtst xorg.libXinerama xorg.xineramaproto xorg.libXrandr
      xorg.randrproto xorg.libXext xorg.xextproto xorg.inputproto
      xorg.recordproto xorg.libXi xorg.libXrender xorg.renderproto
    ];

  meta = {
    description = "A VNC server connected to a real X11 screen";
    homepage = http://www.karlrunge.com/x11vnc/;
  };
}
