{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "2.2.3a";
  name = "discount-${version}";

  src = fetchurl {
    url = "http://www.pell.portland.or.us/~orc/Code/discount/discount-${version}.tar.bz2";
    sha256 = "0m09x9dd75d3pqvmrwr0kqw3dm2x3ss9clj5fxf7lq79lbyxbxbm";
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
