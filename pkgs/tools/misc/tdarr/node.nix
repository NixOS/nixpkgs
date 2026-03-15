{ callPackage }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-ecE4WRvS4xKBYgHEndtpPxFX/F6nVfD9cnVYlFGIoRI=";
    linux_arm64 = "sha256-WzjQGq6mHS5DAK9GgX9tI77l/p8sw+m2kEprKMkJWVM=";
    darwin_x64 = "sha256-plWvMTNMBeJNEUtshIz/3dgOvo795Q8IsuIgZImdRdY=";
    darwin_arm64 = "sha256-i7GS+Y9P+q/kdg37Qq6KuKGQz4Cv9F/VDAVTZy/DIuA=";
  };
}
