{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sg3_utils-1.42";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tgz";
    sha256 = "1wwy7iiz1lvc32c777yd4vp0c0dqfdlm5jrsm3aa62xx141pmjqx";
  };

  meta = {
    homepage = http://sg.danny.cz/sg/;
    description = "Utilities that send SCSI commands to devices";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
