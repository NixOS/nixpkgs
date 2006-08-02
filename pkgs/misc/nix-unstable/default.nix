{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre5896";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre5896/nix-0.10pre5896.tar.bz2;
    md5 = "509d4a452cbf2894a86184b5eaf45abd";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;

  # uncomment if you want to be able to use nix-prefetch-url when NIX_ROOT
  # is set
  #patches = [./nix-0.10pre5679.patch];
  patches = [./nix-0.10pre5896-date.patch ./nix-0.10pre5896-paths.patch ./nix-0.10pre5896-chroot-once.patch];
}
