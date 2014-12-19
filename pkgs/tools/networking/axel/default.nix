{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.4";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "0dl0r9byd2ps90cq2nj1y7ib6gnkb5y9f3a3fmhcnjrm9smmg6im";
  };

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
