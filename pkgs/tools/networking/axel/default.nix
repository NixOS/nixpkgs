{ stdenv, fetchurl, gettext, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.7";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "174x4bp4gcwmpf94hdsdxlpk7q7ldgpsicry7x2pa9zw4yz86wl0";
  };

  buildInputs = [ gettext autoreconfHook ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
