{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.43";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "0amm2s67vzfgs0jv59jgj9pqkr6j9glj1chsj292263i94kr5gib";
  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
  '';

  meta = {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = http://sourceforge.net/projects/hdparm/;
    platforms = stdenv.lib.platforms.linux;
  };
}
