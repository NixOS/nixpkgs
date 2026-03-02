{ callPackage }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-+vD5oaoYh/bOCuk/Bxc8Fsm9UnFICownSKvg9i726nk=";
    linux_arm64 = "sha256-2uPtEno0dSdVBg5hCiUuvBCB5tuTOcpeU2BuXPiqdUU=";
    darwin_x64 = "sha256-8O5J1qFpQxD6fzojxjWnbkS4XQoCZauxCtbl/drplfI=";
    darwin_arm64 = "sha256-oA+nTkO4LDAX5/cGkjNOLnPu0Rss9el+4JF8PBEfsPQ=";
  };
}
