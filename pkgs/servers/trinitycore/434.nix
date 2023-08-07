{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  owner = "The-Cataclysm-Preservation-Project";
  version = "TDB434.22011";
  commit = "1a1f0b767dcbb75a526b8f8213e7360f14fa2b7d";
  sha256 = "0286xcfbvs0bknpwkx7wn9i93r96afgv137rwww6cvhnx8lapya0";
  broken = true; # requires openssl<3
})
