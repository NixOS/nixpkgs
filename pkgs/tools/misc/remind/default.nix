{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "remind-3.1.8";
  src = fetchurl {
    url = http://www.roaringpenguin.com/files/download/remind-03.01.08.tar.gz;
    sha256 = "0gvizrpkbanm515bhd6mq9xxs4g4ji9pplswaj4plaqsk3yw0qjw";
  };

  meta = {
    homepage = http://www.roaringpenguin.com/products/remind;
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
