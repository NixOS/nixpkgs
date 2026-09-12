{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-KcFJjWX8+FVY66azStlzs/FRQRAHEMxjG1k7H9IPM3U=";
    linux_arm64 = "sha256-BVy8O0xYG08Rl5imKB3xNQQGQAw0X5bB65wAdM+mgtc=";
    darwin_x64 = "sha256-Up4CXyC4H7O56wp1xF7r6v6F8gElsiYjs+AqZbbAOQU=";
    darwin_arm64 = "sha256-SjcTxrAYEj/lbYZePiGcw2Dp+FcvGzb91KdTrXRE2zw=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
