{ stdenv, fetchurl, autoreconfHook, pkgconfig, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.17.1";

  src = fetchurl {
  url = "https://github.com/axel-download-accelerator/axel/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1mwyps6yvrjxp7mpzc0a2hwr2pw050c63fc9aqjzdzjjw123dfrn";
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
