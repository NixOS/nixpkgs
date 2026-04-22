{ callPackage }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-Xm7xufs4xne/KYDofsYaLCN0G3a2LZy5h4pObGWnVcY=";
    linux_arm64 = "sha256-fIac6EjU0CF7pWSUaIjwe3r1x7Cbgwz41X769ujS1B0=";
    darwin_x64 = "sha256-LnNJ53rLxC6zg8kNsq7ipUzQSXH9kkMjQFbtJJxC2uc=";
    darwin_arm64 = "sha256-JfiFsiFJcZx8fFyO4s0v2PpeQZ/APjRN1FdudzYaeWU=";
  };
}
