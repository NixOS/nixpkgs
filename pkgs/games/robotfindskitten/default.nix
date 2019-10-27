{ stdenv, fetchurl, pkgconfig, ncurses }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "robotfindskitten";
  version = "2.7182818.701";

  src = fetchurl {
    url = "mirror://sourceforge/project/rfk/robotfindskitten-POSIX/mayan_apocalypse_edition/${pname}-${version}.tar.gz";
    sha256 = "06fp6b4li50mzw83j3pkzqspm6dpgxgxw03b60xkxlkgg5qa6jbp";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ];

  makeFlags = [ "execgamesdir=$(out)/bin" ];

  postInstall = ''
    install -Dm644 {nki,$out/share/games/robotfindskitten}/vanilla.nki
  '';

  meta = {
    description = "Yet another zen simulation; A simple find-the-kitten game";
    homepage = http://robotfindskitten.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
