{stdenv, fetchurl, aterm, bdb}:

assert aterm != null && bdb != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

derivation {
  name = "nix-0.5pre807";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/nix-0.5pre807/nix-0.5pre807.tar.bz2;
    md5 = "fa64bfc39de3e8903954328e4a90d530";
  };
  inherit stdenv aterm bdb;
}
