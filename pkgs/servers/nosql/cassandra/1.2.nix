{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.2.19";
  sha256 = "0zkq3ggpk8ra2siar43vmrn6lmvn902p1g2lrgb46ak1vii6w30w";
})
