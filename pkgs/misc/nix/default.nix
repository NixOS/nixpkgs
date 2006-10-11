{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;

stdenv.mkDerivation {
  name = "nix-0.10.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10.1/nix-0.10.1.tar.bz2;
    md5 = "22dc0c024ca5bb477da0b38ba834dbf2";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;
}
