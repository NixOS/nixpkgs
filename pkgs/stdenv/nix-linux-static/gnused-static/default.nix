{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "gnused-static-4.0.7";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/sed-4.0.7-static.tar.gz;
  tarball = "sed-4.0.7-static.tar.gz";
}
