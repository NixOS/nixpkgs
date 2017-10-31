{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.3.110";
  name = "libaio-${version}";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libaio/${name}.tar.gz";
    sha256 = "0zjzfkwd1kdvq6zpawhzisv7qbq1ffs343i5fs9p498pcf7046g0";
  };

  makeFlags = "prefix=$(out)";

  hardeningDisable = stdenv.lib.optional (stdenv.isi686) "stackprotector";

  meta = {
    description = "Library for asynchronous I/O in Linux";
    homepage = http://lse.sourceforge.net/io/aio.html;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
