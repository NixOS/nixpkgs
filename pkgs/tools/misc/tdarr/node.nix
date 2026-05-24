{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-2dH6mZkQeF6ryzbqNqNt/2brCFBj5yuoSKjh7S3ZRwA=";
    linux_arm64 = "sha256-mbMBufdR0WTPJaSD3PxUP5delX3AJP2ytLQVBK2RxlY=";
    darwin_x64 = "sha256-/GCMEmK4eaN/lpOg90HkvNFOBZFrIdQYM3JX1MfEKMU=";
    darwin_arm64 = "sha256-ikb+Dkhqi7Txzmh51VYG9lf2tmLvbo1K7ebX8oLfNoM=";
  };

  includeInPath = [ ccextractor ];
}
