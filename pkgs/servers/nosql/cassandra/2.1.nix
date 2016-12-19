{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.1.15";
  sha256 = "1yc6r4gmxz9c4zghzn6bz5wswz7dz61w7p4x9s5gqnixfp2mlapp";
})
