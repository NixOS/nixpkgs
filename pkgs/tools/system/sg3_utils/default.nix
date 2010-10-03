{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sg3_utils-1.29";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tgz";
    sha256 = "0d1vlijp9y4n3c0sm0zzba38ad87b5v6nh3prgd8sfwvy79720fi";
  };

  meta = {
    homepage = http://sg.danny.cz/sg/;
    description = "Utilities that send SCSI commands to devices";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
