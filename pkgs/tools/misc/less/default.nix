{stdenv, fetchurl, ncurses}:
 
stdenv.mkDerivation {
  name = "less-382";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/less/less-382.tar.gz;
    md5 = "103fe4aef6297b93f0f73f38cc3b1bd7";
  };
 
  buildInputs = [ncurses];
 
}
