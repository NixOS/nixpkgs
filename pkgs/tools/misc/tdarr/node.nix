{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-Irs93mCfSd4bur7vhkWIljiPb3A8Vpqtzty38/R0V+g=";
    linux_arm64 = "sha256-O/sGlPRU51ZdyAK7V/HtCR+/gmFwH8MTEiPWkq5UdX8=";
    darwin_x64 = "sha256-1nueX93u872bLzVrimH1pMvSsctjJQ/yp4dHK//IIPI=";
    darwin_arm64 = "sha256-1uOvv4Azui2mFDmVjk83rD+/4zL6WaCkyM42tUV48x8=";
  };

  includeInPath = [ ccextractor ];
}
