{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "2.2.3";
  name = "discount-${version}";

  src = fetchurl {
    url = "http://www.pell.portland.or.us/~orc/Code/discount/discount-${version}.tar.bz2";
    sha256 = "17797xiaq0kk152pj4rvd9grg4i518x3glnwg1lgl8rry3dbrzx8";
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
