{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "2016-11-23";
  src = fetchurl {
    # Hydra doesn't serve production outputs anymore :(
    url = "https://static.domenkozar.com/nixops-1.5pre0_abcdef.tar.bz2";
    sha256 = "1a4cyd3zvkdjg9rf9ssr7p4i6r89zr483v5nlr5jzjdjjyi3j2bz";
  };
})
