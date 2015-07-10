{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.48";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "1vpvlkrksfwx8lxq1p1nk3ddyzgrwy3rgxpn9kslchdh3jkv95yf";
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
