{ stdenv, fetchurl, autoreconfHook, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.11";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "05askz9pi8kvjyn66rszjfg9arwdzl72jwd38q9h9n5s37vqslky";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
