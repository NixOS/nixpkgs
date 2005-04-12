{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/nix-0.8/nix-0.8.tar.gz;
    md5 = "ec09cf46cfe6467d899b07cf47fc85b6";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;
}
