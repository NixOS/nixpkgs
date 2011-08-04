{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sg3_utils-1.31";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tgz";
    sha256 = "190hhkhl096fxkspkr93lrq1n79xz5c5i2n4n4g998qc3yv3hjyq";
  };

  meta = {
    homepage = http://sg.danny.cz/sg/;
    description = "Utilities that send SCSI commands to devices";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
