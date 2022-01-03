{ branch ? "nightly", libsForQt5, fetchFromGitHub }:
let inherit libsForQt5 fetchFromGitHub;
in {
  nightly = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "1737";
    branchName = branch;
    branchDesc = "A Nintendo 3DS Emulator, this branch contains already reviewed and tested features";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "a6SbUiwWkUc8b5Zwi9k0/IDMbzi2Ctc3I3RLnY4JU0c=";
    };
  };
  canary = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "2007";
    branchName = branch;
    branchDesc = "A Nintendo 3DS Emulator, this branch contains additional features still under review";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "/1U50bDj+EB9o+4eY+aMYt74iA8iBPmv5qTv2TY0T8E=";
    };
  };
}.${branch}
