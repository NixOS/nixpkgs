{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-436";
 
  src = fetchurl {
    url = http://www.greenwoodsoftware.com/less/less-436.tar.gz;
    sha256 = "1lilcx6qrfr2dqahv7r10j9h2v86w5sb7m8wrx2sza9ifkq6z8ap";
  };
 
  buildInputs = [ncurses];
 
}
