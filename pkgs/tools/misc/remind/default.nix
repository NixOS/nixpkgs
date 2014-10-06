{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "remind-3.1.8";
  src = fetchurl {
    url = http://www.roaringpenguin.com/files/download/remind-03.01.13.tar.gz;
    sha256 = "0kzw1d53nlj90qfsibbs2gkzp1hamqqxpj57ip4kz1j1xgan69ng";
  };

  meta = {
    homepage = http://www.roaringpenguin.com/products/remind;
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = with stdenv.lib.platforms; linux;
  };
}
