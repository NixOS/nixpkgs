{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.2.11";
  sha256 = "0r39mm5ibdn9dqv11n4x33vcb5247r6fl6r07l6frqp6i36ilvl6";
})
