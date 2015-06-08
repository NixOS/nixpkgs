{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "remind-3.1.14";
  src = fetchurl {
    url = http://www.roaringpenguin.com/files/download/remind-03.01.14.tar.gz;
    sha256 = "1b9ij3r95lf14q6dyh8ilzc3y5yxxc1iss8wj3i49n6zjvklml8a";
  };

  meta = {
    homepage = http://www.roaringpenguin.com/products/remind;
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric raskin kovirobi];
    platforms = with stdenv.lib.platforms; linux;
  };
}
