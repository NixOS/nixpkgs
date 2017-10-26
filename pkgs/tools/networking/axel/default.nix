{ stdenv, fetchurl, autoreconfHook, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.15";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "0wm16s129615i7rw48422q3x3ixr4v2p9942p0s6qk2fjlc3y8hf";
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
