{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.4.26";
  sha256 = "sha256-/erBv/Asi/MfoSvAcQ647VAgOfiViPunFWmvy/W9J18=";
})
