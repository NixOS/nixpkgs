{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre6593";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre6593/nix-0.10pre6593.tar.bz2;
    md5 = "7aeb986b0803119891244f0ab936305d";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;

  # uncomment if you want to be able to use nix-prefetch-url when NIX_ROOT
  # is set. Not needed to build or install NixOS.
  #patches = [./nix-0.10pre5679.patch];
}
