{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.9";
  sha256 = "1ckaacc1z0j72llklrc4587ia6a0pab02bdyac6g3kl6kqvcz40c";
  generation = "3_11";
})
