{ stdenv, fetchurl, zlib, libibmad }:

stdenv.mkDerivation {
  name = "mstflint-3.7.0-1.18";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/mstflint/mstflint-3.7.0-1.18.gcdb9f80.tar.gz";
    sha256 = "10x4l3i58ynnni18i8qq1gfbqd2028r4jd3frshiwrl9yrj7sxn2";
  };

  buildInputs = [ zlib libibmad ];

  meta = with stdenv.lib; {
    homepage = http://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
