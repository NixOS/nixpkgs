{ stdenv, fetchurl, autoreconfHook, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.13.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "15bi5wx6fyf9k0y03dy5mk2rv06mrfgiyrlh44add9n07wi574p1";
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
