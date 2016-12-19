{ stdenv, fetchurl, zlib, libibmad }:

stdenv.mkDerivation rec {
  name = "mstflint-4.4.0-1.12.gd1edd58";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/mstflint/${name}.tar.gz";
    sha256 = "0kg33i5s5zdc7kigww62r0b824zfw06r757fl6jwrq7lj91j0380";
  };

  buildInputs = [ zlib libibmad ];

  meta = with stdenv.lib; {
    homepage = http://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
