{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.16.0";
  sha256 = "0i8krbi1pc39myspwlvb8ck969c8207hz84lh3qyg5w7syx7dlsg";
})
