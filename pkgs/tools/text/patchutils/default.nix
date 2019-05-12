{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.3.4";
  sha256 = "0xp8mcfyi5nmb5a2zi5ibmyshxkb1zv1dgmnyn413m7ahgdx8mfg";
})
