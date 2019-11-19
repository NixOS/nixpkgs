{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "gobi_loader";
  version = "0.7";

  src = fetchurl {
    url = "https://www.codon.org.uk/~mjg59/gobi_loader/download/${pname}-${version}.tar.gz";
    sha256 = "0jkmpqkiddpxrzl2s9s3kh64ha48m00nn53f82m1rphw8maw5gbq";
  };

  makeFlags = "prefix=${placeholder "out"}";

  meta = with stdenv.lib; {
    description = "Firmware loader for Qualcomm Gobi USB chipsets";
    homepage = "https://www.codon.org.uk/~mjg59/gobi_loader/";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ "0x4A6F" ];
    platforms = platforms.linux;
  };
}
