{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.2";
  sha256 = "02khwad28ar2jjdfssysx262bgwgirm9967gnfhw9ga7wvipncm0";
})
