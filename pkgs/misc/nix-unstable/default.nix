{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre5429";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre5479/nix-0.10pre5479.tar.bz2;
    md5 = "20055c95996a694235d09a47aefa24c1";
  };
  buildInputs = [aterm bdb perl curl];
  #patches = [./nix-profile-0.9.2.patch];
  inherit storeDir stateDir aterm bdb;
}
