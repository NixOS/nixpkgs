{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-418";
 
  src = fetchurl {
    url = http://www.greenwoodsoftware.com/less/less-418.tar.gz;
    sha256 = "1d03n4wx8y1gmf2m8yawzg6ixmfrixcai5l14p9pj8q13gbgqcpm";
  };
 
  buildInputs = [ncurses];
 
}
