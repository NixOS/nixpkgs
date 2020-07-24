{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sg3_utils-1.45";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tgz";
    sha256 = "0qasc3qm4i8swjfaywiwpgz76gdxqvm47qycxgmprbsjmxqwk1qb";
  };

  meta = with stdenv.lib; {
    homepage = "http://sg.danny.cz/sg/";
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
