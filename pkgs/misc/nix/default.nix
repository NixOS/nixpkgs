{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.9.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.9.2/nix-0.9.2.tar.bz2;
    md5 = "fc3a24f72760e357ac29935b2aebce0b";
  };
  buildInputs = [aterm bdb perl curl];
  patches = [./nix-profile-0.9.2.patch];
  inherit storeDir stateDir aterm bdb;
}
