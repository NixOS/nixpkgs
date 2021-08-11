{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sg3_utils";
  version = "1.46r862";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${pname}-${version}.tgz";
    sha256 = "s2UmU+p3s7Hoe+GFri2q+/3XLBICc+h04cxM86yaAs8=";
  };

  meta = with lib; {
    homepage = "http://sg.danny.cz/sg/";
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
