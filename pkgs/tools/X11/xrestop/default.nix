{ lib, stdenv, fetchurl, xorg, pkg-config, ncurses }:
stdenv.mkDerivation {

  pname = "xrestop";
  version = "0.4";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/xrestop-0.4.tar.gz";
    sha256 = "0mz27jpij8am1s32i63mdm58znfijcpfhdqq1npbmvgclyagrhk7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorg.libX11 xorg.libXres xorg.libXext ncurses ];

  meta = {
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2;
  };
}
