{stdenv, fetchurl, expat} :

stdenv.mkDerivation {
  name = "sablotron-1.0.3";
  src = fetchurl {
    url = http://download-1.gingerall.cz/download/sablot/Sablot-1.0.3.tar.gz;
    md5 = "72654c4b832e7562f8240ea675577f5e";
  };
  buildInputs = [expat];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
