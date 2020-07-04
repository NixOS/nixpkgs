{ stdenv, fetchurl, pkgconfig, ncurses }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "robotfindskitten";
  version = "2.8284271.702";

  src = fetchurl {
    url = "mirror://sourceforge/project/rfk/robotfindskitten-POSIX/ship_it_anyway/${pname}-${version}.tar.gz";
    sha256 = "1bwrkxm83r9ajpkd6x03nqvmdfpf5vz6yfy0c97pq3v3ykj74082";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ];

  makeFlags = [ "execgamesdir=$(out)/bin" ];

  postInstall = ''
    install -Dm644 {nki,$out/share/games/robotfindskitten}/vanilla.nki
  '';

  meta = {
    description = "Yet another zen simulation; A simple find-the-kitten game";
    homepage = "http://robotfindskitten.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
