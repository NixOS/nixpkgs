{ stdenv, fetchurl, autoreconfHook, pkgconfig, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.16.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "0v3hgqrpqqqkj8ghaky88a0wpnpwqd72vd04ywlbhgfzfkfrllk4";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    license = licenses.gpl2;
  };
}
