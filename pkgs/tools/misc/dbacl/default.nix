{fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "dbacl-1.14";
  src = fetchurl {
    url = "http://www.lbreyer.com/gpl/${name}.tar.gz";
    md5 = "85bfd88bc20f326dc0f31e794948e21c";
  };

  meta = {
    homepage = http://dbacl.sourceforge.net/;
    longDescription = "a digramic Bayesian classifier for text recognition.";
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.gpl3;
  };
}
