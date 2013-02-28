{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-451";
 
  src = fetchurl {
    url = http://www.greenwoodsoftware.com/less/less-451.tar.gz;
    sha256 = "9fe8287c647afeafb4149c5dedaeacfd20971ed7c26c7553794bb750536b5f57";
  };
 
  buildInputs = [ncurses];
 
}
