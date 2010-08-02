{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation rec {
  name = "x2vnc-1.7.2";

  src = fetchurl {
    url = http://fredrik.hubbe.net/x2vnc/x2vnc-1.7.2.tar.gz;
    sha256 = "00bh9j3m6snyd2fgnzhj5vlkj9ibh69gfny9bfzlxbnivb06s1yw";
  };

  buildInputs =
    [ xorg.libX11 xorg.xproto xorg.xextproto xorg.libXext
      xorg.libXrandr xorg.randrproto
    ];

  preInstall = "ensureDir $out";

  meta = {
    homepahe = http://fredrik.hubbe.net/x2vnc.html;
    description = "A program to control a remote VNC server";
  };
}
