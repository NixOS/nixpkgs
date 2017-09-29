{ stdenv, fetchurl, autoreconfHook, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.14.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "0fayfpyc9cs6yp474400nyjbix6aywicz6pw17rzm4m7k06q5xmc";
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
