{ stdenv, fetchurl, texinfo }:
stdenv.mkDerivation rec {

  name = "polipo-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://freehaven.net/~chrisd/polipo/${name}.tar.gz";
    sha256 = "0dh4kjj6vfb75nxv7q3y2kvxsq8cwrd8svsrypa810jln8x8lign";
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