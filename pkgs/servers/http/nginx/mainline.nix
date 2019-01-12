{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.8";
  sha256 = "11q7njr0khv8hb96bclyw5f75gvm12nw3jjgmq9rifbym2yazgd8";
})
