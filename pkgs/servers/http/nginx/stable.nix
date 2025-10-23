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
  ];
}
