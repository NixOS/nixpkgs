{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.52";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "1djgxhfadd865dcrl6dp7dvjxpaisy7mk17mbdbglwg24ga9qhn3";

  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
    '';

  meta = with stdenv.lib; {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = https://sourceforge.net/projects/hdparm/;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.fuuzetsu ];
  };

}
