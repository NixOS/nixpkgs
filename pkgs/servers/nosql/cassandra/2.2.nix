{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.2.19";
  sha256 = "1f8axpxxpmzlb22k3lqsnw3096qjp6xd36brvq5xbdk698jw15jl";
})
