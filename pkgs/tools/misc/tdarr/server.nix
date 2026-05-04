{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-kQ6BMr336SqPDIIjX+ky4BiaMHYFdsTRhmzwsutX5GM=";
    linux_arm64 = "sha256-PoCwWRbdYFn1ZGUbbJQwDgB0Pk3BflEkyFyvKPSWJ3g=";
    darwin_x64 = "sha256-ax9WRw/aMoSBI8zrQEmnpX58G4FlYWCMgSwDg10efe8=";
    darwin_arm64 = "sha256-SJ0fflHrJMjlZuNZauFyhITs5nI7lu3kVUSZAnaS9a4=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
