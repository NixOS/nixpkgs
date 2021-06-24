{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hdparm";
  version = "9.60";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/hdparm-${version}.tar.gz";
    sha256 = "1k1mcv7naiacw1y6bdd1adnjfiq1kkx2ivsadjwmlkg4fff775w3";
  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
    '';

  meta = with lib; {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = "https://sourceforge.net/projects/hdparm/";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ ];
  };

}
