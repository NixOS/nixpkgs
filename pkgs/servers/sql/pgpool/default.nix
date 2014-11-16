{ stdenv, fetchurl, postgresql }:

stdenv.mkDerivation rec {
  name = "pgpool-II-3.4.0";

  src = fetchurl {
    url = "http://www.pgpool.net/download.php?f=${name}.tar.gz";
    sha256 = "1aind5rbdld5ip92xlh4f6dgvdc4zxzgzi5n33xbvdrsrvagbc4j";
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
