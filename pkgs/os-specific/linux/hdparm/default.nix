{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.55";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "1ivdvrzimaayiq03by8mcq0mhmdljndj06h012zkdpw34irnpixm";

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
