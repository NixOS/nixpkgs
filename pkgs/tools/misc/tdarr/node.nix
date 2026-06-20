{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-5wxf5E1M1bBXrv8/cBUZ7Edg90TnxY6UeXZpmkyJC0U=";
    linux_arm64 = "sha256-jnrXHv5/u9YaMCwKy5QzcilRdEE60PQtTTMhoVsMGKw=";
    darwin_x64 = "sha256-Ri4lop0XyE2oFUn74ZIx1UMhf/wVILnlwlRlIHzwr/A=";
    darwin_arm64 = "sha256-ZSMsngeJM6QX0Z0J0ARH8Jo7NcH3CMwn9/Rk11VU3k8=";
  };

  includeInPath = [ ccextractor ];
}
