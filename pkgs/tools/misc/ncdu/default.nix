{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ncdu-${version}";
  version = "1.14";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${name}.tar.gz";
    sha256 = "0i4cap2z3037xx2rdzhrlazl2igk3xy4ncddp9j7xqi1mcx7i566";
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
