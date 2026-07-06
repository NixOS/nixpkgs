{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-hF4W72VEWAryCoLZecrwdT98iN3sARaPWJnEApFeHCw=";
    linux_arm64 = "sha256-wJ3fZLJKUHama1P6YTslTb3fiYI4qjGm5VdHKGcG8k4=";
    darwin_x64 = "sha256-cL6REyGqwFemXLMkgAXy9PTS0j7maT1lBNzckTL4Ez0=";
    darwin_arm64 = "sha256-0LFTw4fbdFXcEYGVk1C1UOVRAh/MfGctFzfKB/mr6lM=";
  };

  includeInPath = [ ccextractor ];
}
