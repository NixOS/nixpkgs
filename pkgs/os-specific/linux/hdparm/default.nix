{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "hdparm-6.9";

  src = fetchurl {
    url = mirror://sourceforge/hdparm/hdparm-6.9.tar.gz;
    sha256 = "01pyb9jmcv9nl1ig39s1i58fwgijqhjc5q1vxscbw0bd563fvrna";
  };

  preBuild = "
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
  ";
}
