{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre5214";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre5214/nix-0.10pre5214.tar.bz2;
    md5 = "a6e9e551a5d45d5850e4b94f8c1c8f0a";
  };
  buildInputs = [aterm bdb perl curl];
  #patches = [./nix-profile-0.9.2.patch];
  inherit storeDir stateDir aterm bdb;
}
