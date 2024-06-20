{ lib, stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  pname = "polipo";
  version = "1.1.1";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/${pname}-${version}.tar.gz";
    sha256 = "05g09sg9qkkhnc2mxldm1w1xkxzs2ylybkjzs28w8ydbjc3pand2";
  };

  buildInputs = [ texinfo ];
  makeFlags = [ "PREFIX=$(out)" "LOCAL_ROOT=$(out)/share/polipo/www" ];

  meta = with lib; {
    homepage = "http://www.pps.jussieu.fr/~jch/software/polipo/";
    description = "Small and fast caching web proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.all;
    knownVulnerabilities = [
      "Unmaintained upstream: https://github.com/jech/polipo/commit/4d42ca1b5849"
    ];
  };
}
