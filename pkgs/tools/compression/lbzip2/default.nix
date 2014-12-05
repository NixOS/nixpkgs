{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "lbzip2-2.5";

  src = fetchurl {
    url = "http://archive.lbzip2.org/${name}.tar.gz";
    sha256 = "1sahaqc5bw4i0iyri05syfza4ncf5cml89an033fspn97klmxis6";
  };

  meta = with stdenv.lib; {
    homepage = http://lbzip2.org/;
    description = "parallel bzip2 compression utility";
    license = licenses.gpl3;
    maintainers = maintainers.abbradar;
    platforms = platforms.unix;
  };
}
