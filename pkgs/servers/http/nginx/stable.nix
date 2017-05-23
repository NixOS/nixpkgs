{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.12.0";
  sha256 = "0c2vg6530qplwk8rhldww5r3cwcbw1avka53qg9sh85nzlk2w8ml";
})
