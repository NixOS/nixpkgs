{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "coreutils-static-5.0";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/coreutils-5.0-static.tar.gz;
  tarball = "coreutils-5.0-static.tar.gz";
}
