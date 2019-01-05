{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.7";
  sha256 = "14yz5cag9jdi088kdyammpi0ixrzi91bc0nwdldj42hfdhpyl8lg";
})
