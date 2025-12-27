{ callPackage, fetchpatch, ... }@args:

callPackage ./generic.nix args {
  version = "1.28.0";
  hash = "sha256-xrXGsIbA3508o/9eCEwdDvkJ5gOCecccHD6YX1dv92o=";
  extraPatches = [
    (fetchpatch {
      name = "CVE-2025-53859.patch";
      url = "https://nginx.org/download/patch.2025.smtp.txt";
      hash = "sha256-v49sLskFNMoKuG8HQISw8ST7ga6DS+ngJiL0D3sUyGk=";
    })
  ]
  # Backport update mime-types from freenginx.
  ++ [
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
