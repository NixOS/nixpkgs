{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.5pre957";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/nix-0.5pre957/nix-0.5pre957.tar.bz2;
    md5 = "d3240f08ad7ee3f1eeab26cd2f8ab9b1";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;
}
