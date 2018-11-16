{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sg3_utils-1.44";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tgz";
    sha256 = "0yxfbkd48mbzipwmggcvpq60zybsb6anrca878si26z7496nibld";
  };

  meta = with stdenv.lib; {
    homepage = http://sg.danny.cz/sg/;
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
