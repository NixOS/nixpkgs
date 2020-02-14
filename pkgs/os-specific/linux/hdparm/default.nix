{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.58";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "03z1qm8zbgpxagk3994lvp24yqsshjibkwg05v9p3q1w7y48xrws";

  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
    '';

  meta = with stdenv.lib; {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = https://sourceforge.net/projects/hdparm/;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ ];
  };

}
