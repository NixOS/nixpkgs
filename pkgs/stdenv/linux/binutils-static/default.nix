{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit gnutar gzip curl;
  name = "binutils-static-2.15";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/binutils-2.15-static.tar.gz;
  tarball = "binutils-2.15-static.tar.gz";
}
