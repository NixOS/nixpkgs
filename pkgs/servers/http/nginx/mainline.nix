{ callPackage, fetchpatch, ... }@args:

callPackage ./generic.nix args {
  version = "1.29.4";
  hash = "sha256-Wn037uUFhm+6tYEPqfeCR9bV2RV6WVxOenIEMUHdqyU=";
  # Backport update mime-types from freenginx.
  extraPatches = [
    (fetchpatch {
      url = "https://github.com/freenginx/nginx/commit/77ee09313a4281d891f9fa0bf325de36e9a8c933.patch";
      sha256 = "sha256-1SB+SwtHx1zU31S3EVUs73b57LIRxD5jr5FHqAgluqM=";
    })
    (fetchpatch {
      url = "https://github.com/freenginx/nginx/commit/6e44afc355ae5262506bdbf9d692d5cc7cb20994.patch";
      sha256 = "sha256-pKlXcXPGjmvtPH2P2ewkakjNrQ4w/x3Y2GHjgg4OdIg=";
    })
    (fetchpatch {
      url = "https://github.com/freenginx/nginx/commit/c85785e4116e6b175946682fc6d17d32312c20ee.patch";
      sha256 = "sha256-gKXMUHCBiahpfNTgBUoxm5haCweAIHZHHCGL72QkoGA=";
    })
  ];
}
