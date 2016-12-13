{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.7";
  sha256 = "03ihv5v8qasifh4wlql0ggbqkyvak29g0h5fqzka69i15fsvwm8d";
})
