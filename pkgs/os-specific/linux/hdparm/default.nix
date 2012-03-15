{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.39";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "1siw9c2hrsck47jr9wpip9n677g31qd34y8whkq9dai68npm1mbj";
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
