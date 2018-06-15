{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.12";
  sha256 = "1pl5ii1w2ycxprxk8zdnxlpdd1dia6hyrns7mnqkm3fv5ihgb4pv";
})
