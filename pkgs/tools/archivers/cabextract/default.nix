{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cabextract-1.9.1";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/${name}.tar.gz";
    sha256 = "19qwhl2r8ip95q4vxzxg2kp4p125hjmc9762sns1dwwf7ikm7hmg";
  };

  meta = with stdenv.lib; {
    homepage = https://www.cabextract.org.uk/;
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
