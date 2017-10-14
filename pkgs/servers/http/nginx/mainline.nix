{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.5";
  sha256 = "0blzna6h76xd7ddz37yb7yqg4yx7gpwsz8zbg8vlbxxk552bjx8f";
})
