{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "diffutils-static-2.8.1";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/diffutils-2.8.1-static.tar.gz;
  tarball = "diffutils-2.8.1-static.tar.gz";
}
