{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "axel-2.4";
  src = fetchurl {
    urls = [
      #https://alioth.debian.org/frs/download.php/3016/axel-2.4.tar.bz2
      mirror://debian/pool/main/a/axel/axel_2.4.orig.tar.gz
    ];
    sha256 = "0dl0r9byd2ps90cq2nj1y7ib6gnkb5y9f3a3fmhcnjrm9smmg6im";
  };

  meta = {
    description = "Console downloading program with some features for parallel connections for faster downloading";
  };
}
