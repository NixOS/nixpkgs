{ stdenv, fetchurl, texinfo }:
stdenv.mkDerivation rec {

  name = "polipo-${version}";
  version = "1.0.4.1";

  src = fetchurl {
    url = "http://freehaven.net/~chrisd/polipo/${name}.tar.gz";
    sha256 = "1ykwkyvmdw6fsaj2hc40971pkwf60hvi9c43whijim00qvgbyvwd";
  };

  buildInputs = [ texinfo ];
  makeFlags = [ "PREFIX=$(out)" "LOCAL_ROOT=$(out)/share/polipo/www" ];

  meta = with stdenv.lib; {
    homepage = http://www.pps.jussieu.fr/~jch/software/polipo/;
    description = "A small and fast caching web proxy";
    license = licenses.mit;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}