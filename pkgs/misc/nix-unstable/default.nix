{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre5529";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre5529/nix-0.10pre5529.tar.bz2;
    md5 = "583a92e4df47a20d237d2a89bdad9296";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;
}
