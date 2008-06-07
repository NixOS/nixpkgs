{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "hdparm-8.7";

  src = fetchurl {
    url = mirror://sourceforge/hdparm/hdparm-8.7.tar.gz;
    sha256 = "1gbyywsam769fdsgcy2clkfik9h2drad78h1xnh55b9c6fjlacmq";
  };

  preBuild = "
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
  ";

  meta = {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = http://sourceforge.net/projects/hdparm/;
  };
}
