{stdenv, fetchurl, aterm, bdb}:

assert aterm != null && bdb != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

derivation {
  name = "nix-0.5pre792";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/nix-0.5pre792/nix-0.5pre792.tar.bz2;
    md5 = "8f8747478eac5b2df5791400af506cf0";
  };
  inherit stdenv aterm bdb;
}
