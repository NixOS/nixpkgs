{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "gawk-static-3.1.3";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/gawk-3.1.3-static.tar.gz;
  tarball = "gawk-3.1.3-static.tar.gz";
}
