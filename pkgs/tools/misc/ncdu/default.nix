{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.15";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "1ywpa8yg74a5xa46f0qig92xw5z5s1lmspwzcslr497brk2ksnaa";
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
