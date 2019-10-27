{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation {
  name = "x2vnc-1.7.2";

  src = fetchurl {
    url = https://fredrik.hubbe.net/x2vnc/x2vnc-1.7.2.tar.gz;
    sha256 = "00bh9j3m6snyd2fgnzhj5vlkj9ibh69gfny9bfzlxbnivb06s1yw";
  };

  buildInputs = with xorg; [
      libX11 xorgproto libXext libXrandr
    ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = http://fredrik.hubbe.net/x2vnc.html;
    description = "A program to control a remote VNC server";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
