{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sg3_utils-1.46r862";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tgz";
    sha256 = "sha256-s2UmU+p3s7Hoe+GFri2q+/3XLBICc+h04cxM86yaAs8=";
  };

  meta = with lib; {
    homepage = "http://sg.danny.cz/sg/";
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
