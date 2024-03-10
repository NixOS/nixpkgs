{ lib, stdenv, fetchurl, xorg, pkg-config, ncurses }:

stdenv.mkDerivation rec {
  pname = "xrestop";
  version = "0.6";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/xrestop-${version}.tar.xz";
    hash = "sha256-Li7BEcSyeYtdwtwrPsevT2smGUbpA7jhTbBGgx0gOyk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorg.libX11 xorg.libXres xorg.libXext ncurses ];

  meta = with lib; {
    description = "A 'top' like tool for monitoring X Client server resource usage";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrestop";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    mainProgram = "xrestop";
  };
}
