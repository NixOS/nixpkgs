{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre5609";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre5609/nix-0.10pre5609.tar.bz2;
    md5 = "83a7059062189161b9c1687080f837dd";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;
}
