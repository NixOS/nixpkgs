{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.6";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "17j6kp4askr1q5459ak71m1bm0qa3dyqbxvi5ifh2bjvjlp516mx";
  };

  buildInputs = [ gettext ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
