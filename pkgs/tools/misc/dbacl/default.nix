{fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "dbacl-1.14";
  src = fetchurl {
    url = "http://www.lbreyer.com/gpl/${name}.tar.gz";
    sha256 = "0224g6x71hyvy7jikfxmgcwww1r5lvk0jx36cva319cb9nmrbrq7";
  };

  meta = {
    homepage = http://dbacl.sourceforge.net/;
    longDescription = "a digramic Bayesian classifier for text recognition.";
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
