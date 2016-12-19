{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "discount-${version}";

  src = fetchurl {
    url = "http://www.pell.portland.or.us/~orc/Code/discount/discount-${version}.tar.bz2";
    sha256 = "1wxrv86xr8cacwhzkyzmfxg58svfnn3swbpbk5hq621ckk19alxj";
  };
  patches = ./fix-configure-path.patch;
  configureScript = "./configure.sh";

  meta = with stdenv.lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = licenses.bsd3;
    maintainers = [ maintainers.shell ];
    platforms = platforms.unix;
  };
}
