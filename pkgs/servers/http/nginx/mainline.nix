{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.1";
  sha256 = "0xk7gcsgwhz047h54adn8crnkrkr7g1z79w8ik34v6k0lrr6r1d5";
})
