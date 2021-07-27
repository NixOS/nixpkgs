{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sg3_utils";
  version = "1.45";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/sg3_utils-${version}.tgz";
    sha256 = "0qasc3qm4i8swjfaywiwpgz76gdxqvm47qycxgmprbsjmxqwk1qb";
  };

  meta = with lib; {
    homepage = "http://sg.danny.cz/sg/";
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
