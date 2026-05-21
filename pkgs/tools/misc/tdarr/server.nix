{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-q69RkTtI8yrEm08JlSxBuE6BaCoQhkEt7v5ONeDLICA=";
    linux_arm64 = "sha256-4S1Tu23Xd3MqsCKxzGVB+07nlulR2uuQVBMrni/sQUU=";
    darwin_x64 = "sha256-0+4gHTpLJpP+3mraSOx6tGpwcxlt1cPt6Cnn+xQLOok=";
    darwin_arm64 = "sha256-VQtzUAYyDjGJpjBAvragIOT7fcV61bIp6ESABTOoFHs=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
