{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit curl gzip gnutar;
  name = "gnugrep-static-2.5.1";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/grep-2.5.1-static.tar.gz;
  tarball = "grep-2.5.1-static.tar.gz";
}
