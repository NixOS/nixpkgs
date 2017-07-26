{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.3";
  sha256 = "0whdpgfb1y9r7f3y91r4m0wpgrwwdl2byahp9a7gn0n30j0gjwsv";
})
