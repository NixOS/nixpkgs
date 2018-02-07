{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.53";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "1rb5086gp4l1h1fn2nk10ziqxjxigsd0c1zczahwc5k9vy8zawr6";

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
