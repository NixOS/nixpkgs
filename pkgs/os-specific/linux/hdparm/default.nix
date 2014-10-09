{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.45";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "0sc6yf3k6sd7n6a2ig2my9fjlqpak3znlyw7jw4cz5d9asm1rc13";
  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
  '';

  meta = {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = http://sourceforge.net/projects/hdparm/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
