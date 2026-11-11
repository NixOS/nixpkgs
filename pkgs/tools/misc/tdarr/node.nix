{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-F7P0DZ4J10cgwbME1qcWYnJcMlcsALJ+z6u/eVTv5g0=";
    linux_arm64 = "sha256-oKapd+SjpercZecXCjojbsjHem5oWxctycj/woD0Bwc=";
    darwin_x64 = "sha256-RmRngSwtU5ZMlE8yPy+Am6DzMmuiFihbeIk1yn/85Gc=";
    darwin_arm64 = "sha256-muqjEYYTDckM8FesRrE8rAxPOIzMyLcnXOSGcfKfw5Y=";
  };

  includeInPath = [ ccextractor ];
}
