{stdenv, gnutar, gzip, curl}:
 
stdenv.mkDerivation {
  inherit gnutar gzip curl;
  name = "bzip2-static-1.0.2";
  builder = ./builder.sh;
  src = http://losser.st-lab.cs.uu.nl/~armijn/.nix/bzip2-1.0.2-static.tar.gz;
  tarball = bzip2-1.0.2-static.tar.gz;
}
