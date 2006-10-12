{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-394";
 
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/less-394.tar.gz;
    md5 = "a9f072ccefa0d315b325f3e9cdbd4b97";
  };
 
  buildInputs = [ncurses];
 
}
