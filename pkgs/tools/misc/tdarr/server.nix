{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-YbEFgvOEAY5HGyTZw9vr4SC85zLQHUQKq++Qbsg1+5A=";
    linux_arm64 = "sha256-PGguxjOGVUPV5CW3iAtoehnxqGkTe9UA6Vu+7bf6DlQ=";
    darwin_x64 = "sha256-Gya1DmrLM5UCChwocEwdjYxSWECOl5Ew/e8LpmPQB7M=";
    darwin_arm64 = "sha256-RJYQZ4L49WTwgMj+vZYFd5Kl3gX1DrkR+fF5E7L9fVs=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
