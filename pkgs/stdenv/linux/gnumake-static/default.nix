{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "gnumake-static-3.80";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/make-3.80-static.tar.gz;
  tarball = "make-3.80-static.tar.gz";
}
