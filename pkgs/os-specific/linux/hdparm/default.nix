{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.51";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "14ax5lyzhigx58ing7adbfyzisv0fqajbmzphg149rnb3s4xiyhs";

  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
    '';

  meta = with stdenv.lib; {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = http://sourceforge.net/projects/hdparm/;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.fuuzetsu ];
  };

}
