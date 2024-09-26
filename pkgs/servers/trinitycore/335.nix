{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "TDB335.23061";
  commit = "40d1f7a2e8fa54b3c9432b4432d6df968ec60cc4";
  branch = "3.3.5";
  hash = "sha256-gpA0/6mDjTDu3cwwqEPnmbSa2LhNPttuqXLTlzhxjro=";
})
