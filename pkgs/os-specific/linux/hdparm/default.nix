{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hdparm";
  version = "9.63";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/hdparm-${version}.tar.gz";
    sha256 = "sha256-cHhd6uu6WHeonBI1aLQd7pkNpV/FFCDxP2CaEHKJlpE=";
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
