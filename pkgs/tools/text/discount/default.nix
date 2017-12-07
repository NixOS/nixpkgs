{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "2.2.2";
  name = "discount-${version}";

  src = fetchurl {
    url = "http://www.pell.portland.or.us/~orc/Code/discount/discount-${version}.tar.bz2";
    sha256 = "0r4gjyk1ngx47zhb25q0gkjm3bz2m5x8ngrk6rim3y1y3rricygc";
  };

  patches = ./fix-configure-path.patch;
  configureScript = "./configure.sh";

  meta = with stdenv.lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = http://www.pell.portland.or.us/~orc/Code/discount/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ shell ndowens ];
    platforms = platforms.unix;
  };
}
