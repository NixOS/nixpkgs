{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-416";
 
  src = fetchurl {
    url = http://www.greenwoodsoftware.com/less/less-416.tar.gz;
    sha256 = "1nsmnczqqkiir1gi11dzrh1gssn2zmxrzqd692qy92dh86bmfilv";
  };
 
  buildInputs = [ncurses];
 
}
