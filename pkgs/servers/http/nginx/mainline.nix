{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.8";
  sha256 = "1ib4hkngj9z7pl73lnn96d85m7v2wwb56nkypwx7d6pm3z1vc444";
})
