{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "remind-3.1.15";
  src = fetchurl {
    url = http://www.roaringpenguin.com/files/download/remind-03.01.15.tar.gz;
    sha256 = "1hcfcxz5fjzl7606prlb7dgls5kr8z3wb51h48s6qm8ang0b9nla";
  };

  meta = {
    homepage = http://www.roaringpenguin.com/products/remind;
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric raskin kovirobi];
    platforms = with stdenv.lib.platforms; linux;
  };
}
