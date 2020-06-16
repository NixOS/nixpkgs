{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.15.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "1c1zxalm5asyhn4p1hd51h7khw17515gbqmvdz63kc8xpx6xqbdh";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub zowoq ];
  };
}
