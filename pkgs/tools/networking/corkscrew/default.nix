{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "corkscrew-2.0";

  src = fetchurl {
    url = "http://agroman.net/corkscrew/${name}.tar.gz";
    sha256 = "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be";
  };

  meta = with stdenv.lib; {
    homepage    = http://agroman.net/corkscrew/;
    description = "A tool for tunneling SSH through HTTP proxies";
    license = stdenv.lib.licenses.gpl2;
  };
}
