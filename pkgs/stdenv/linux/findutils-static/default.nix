{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "findutils-static-4.1.20";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/findutils-4.1.20-static.tar.gz;
  tarball = "findutils-4.1.20-static.tar.gz";
}
