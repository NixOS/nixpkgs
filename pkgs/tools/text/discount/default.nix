{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "2.1.6";
  name = "discount-${version}";

  src = fetchurl {
    url = "http://www.pell.portland.or.us/~orc/Code/discount/discount-${version}.tar.bz2";
    sha256 = "15h726m5yalq15hkxxfw4bxwd6wkwkan5q7s80pgi1z32ygb4avh";
  };
  patches = ./fix-configure-path.patch;
  configureScript = "./configure.sh";

  meta = with stdenv.lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = licenses.bsd3;
    maintainers = [ maintainers.shell ];
  };
}
