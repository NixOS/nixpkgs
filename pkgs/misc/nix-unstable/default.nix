{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre6047";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre6047/nix-0.10pre6047.tar.bz2;
    md5 = "40f68dd3555dbb12478a468df301c3a9";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;

  # uncomment if you want to be able to use nix-prefetch-url when NIX_ROOT
  # is set
  #patches = [./nix-0.10pre5679.patch];
  patches = [./nix-0.10pre5896-paths.patch ./nix-0.10pre5896-chroot-once.patch];
}
