{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  owner = "The-Cataclysm-Preservation-Project";
  version = "TDB434.22011-815"; # git describe --tags
  commit = "bfd31d59c20f6130f1914ceb8b9b1f2d1e797bcd";
  hash = "sha256-HgpsR7qtSvWoFDCJHDMKWK8k9L5dEFkcQ7K4OC5cu/g=";
})
