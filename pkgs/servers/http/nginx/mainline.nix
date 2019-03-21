{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.9";
  sha256 = "0hxfsz1117r91b9fb5hjddyrf1czvb36lh1z7zalqqdskfcbmkz4";
})
