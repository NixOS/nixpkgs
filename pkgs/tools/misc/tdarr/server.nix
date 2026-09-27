{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-VRTtCYWM7F3H4VL79jZIZSgfPdfveMulV6JwtbAE24Y=";
    linux_arm64 = "sha256-V73BKbPpr5htkauhrxDVPbKZdLZMss3Y8IGYzYMeb3Q=";
    darwin_x64 = "sha256-2scrFYx4mt3N+HjzJ43nB+fNIiuvy2prMv0odte/CXM=";
    darwin_arm64 = "sha256-k42yA6Apq6YS7Bp+Ie4ve15XTZmkUGRhNYAnVMh5bEw=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
