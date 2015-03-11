{ stdenv, fetchurl, postgresql }:

stdenv.mkDerivation rec {
  name = "pgpool-II-3.4.1";

  src = fetchurl {
    url = "http://www.pgpool.net/download.php?f=${name}.tar.gz";
    sha256 = "11fy4lvh2n04zmywy4vhp229yxdw8fbirrlvz44j1vnarkb664pd";
  };

  buildInputs = [ postgresql ];

  meta = with stdenv.lib; {
    homepage = http://pgpool.net/mediawiki/index.php;
    description = "a middleware that works between postgresql servers and postgresql clients.";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
