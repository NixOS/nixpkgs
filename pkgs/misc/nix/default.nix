{ stdenv, fetchurl, aterm, bdb, perl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.5pre881";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/nix-0.5pre881/nix-0.5pre881.tar.bz2;
    md5 = "427a4add7b374ea392ec81a3494cfb23";
  };
  buildInputs = [aterm bdb perl];
  inherit storeDir stateDir aterm bdb;
}
