{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.1";
  sha256 = "1vgh4ysnl4xg8g5v6zm78h3sq308r7s17ppbw0ck4bwyfnbddvkg";
})
