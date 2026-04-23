{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-+nxwSGAkA+BPf481N6KHW7s0iJzoGFPWp0XCbsVEwrI=";
    linux_arm64 = "sha256-tA5VX27XmH3C4Bkll2mJlr1BYz5V7PPvzbJeaDht7uI=";
    darwin_x64 = "sha256-jgHEezqtzUWTIvmxsmV1VgaXY9wHePkg6bQO16eSSGI=";
    darwin_arm64 = "sha256-pcPpqFbqYsXf5Og9uC+eF/1kOQ1ZiletDzkk3qavPS0=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
