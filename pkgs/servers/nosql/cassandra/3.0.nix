{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.17";
  sha256 = "0568r5xdy78pl29zby5g4m9qngf29cb9222sc1q1wisapb7zkl2p";
})
