{ stdenv, fetchurl, aterm, bdb, perl, curl
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

assert aterm != null && bdb != null && perl != null;
# assert bdb.version >= 4.2
# assert aterm.version >= 2.0

stdenv.mkDerivation {
  name = "nix-0.10pre6474";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10pre6474/nix-0.10pre6474.tar.bz2;
    md5 = "aed25ae83ada6012a3d924d3747b4c23";
  };
  buildInputs = [aterm bdb perl curl];
  inherit storeDir stateDir aterm bdb;

  # uncomment if you want to be able to use nix-prefetch-url when NIX_ROOT
  # is set. Not needed to build or install NixOS.
  #patches = [./nix-0.10pre5679.patch];
}
