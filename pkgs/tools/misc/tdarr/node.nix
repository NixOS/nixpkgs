{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-77u5Rjd0v3yFPZb0n/lpmpLta6mAxtiDicjECCv17rI=";
    linux_arm64 = "sha256-lmU6UO+K9N9HnXl/3xa12b946ESnSr895MEYhQyKdjs=";
    darwin_x64 = "sha256-wwmZdDClYAyHS2xUF7bU+FzrckV/gKcD6KECEJTkinM=";
    darwin_arm64 = "sha256-j1c+z6v0a7I/k1JM+BUpPrSA/xRpZOZ9+2Rv7Ywgw38=";
  };

  includeInPath = [ ccextractor ];
}
