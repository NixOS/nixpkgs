{ lib, stdenv, fetchurl, automake }:

stdenv.mkDerivation rec {
  pname = "corkscrew";
  version = "2.0";

  src = fetchurl {
    url = "http://agroman.net/corkscrew/corkscrew-${version}.tar.gz";
    sha256 = "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be";
  };

  preConfigure = ''
    ln -sf ${automake}/share/automake-*/config.sub config.sub
    ln -sf ${automake}/share/automake-*/config.guess config.guess
  '';

  meta = with lib; {
    homepage    = "http://agroman.net/corkscrew/";
    description = "A tool for tunneling SSH through HTTP proxies";
    license = lib.licenses.gpl2;
    platforms = platforms.unix;
  };
}
