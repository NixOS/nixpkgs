{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "polipo-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/${name}.tar.gz";
    sha256 = "05g09sg9qkkhnc2mxldm1w1xkxzs2ylybkjzs28w8ydbjc3pand2";
  };

  buildInputs = [ texinfo ];
  makeFlags = [ "PREFIX=$(out)" "LOCAL_ROOT=$(out)/share/polipo/www" ];

  meta = with stdenv.lib; {
    homepage = http://www.pps.jussieu.fr/~jch/software/polipo/;
    description = "A small and fast caching web proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom emery ];
    platforms = platforms.all;
  };
}