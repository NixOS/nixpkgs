{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cabextract";
  version = "1.9.1";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/cabextract-${version}.tar.gz";
    sha256 = "19qwhl2r8ip95q4vxzxg2kp4p125hjmc9762sns1dwwf7ikm7hmg";
  };

  meta = with lib; {
    homepage = "https://www.cabextract.org.uk/";
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
