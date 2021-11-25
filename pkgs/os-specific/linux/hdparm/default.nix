{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hdparm";
  version = "9.62";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/hdparm-${version}.tar.gz";
    sha256 = "sha256-LA+ddc2+2pKKJaEozT0LcSBEXsCRDAsp1MEDjtG+d38=";
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
