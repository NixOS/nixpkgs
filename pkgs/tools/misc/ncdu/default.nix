{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.14.2";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "1cf6a9qw7ljaw09b0g7c5i252dl7wb2mnkrbwwwf7m0c3mf7yyll";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = https://dev.yorhel.nl/ncdu;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
