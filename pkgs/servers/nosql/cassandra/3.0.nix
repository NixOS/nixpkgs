{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.8";
  sha256 = "02chk8q3pbl0y6rijfk2gbd0p1ani8daypsx9m9ingqkdx8ajljq";
})
