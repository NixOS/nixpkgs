{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.6";
  sha256 = "1y7qcdpjskjc1iwwrjqsbgm74jpnf873pwv17clsy83ak1pzq4l5";
})
