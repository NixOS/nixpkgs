{ branch ? "nightly", libsForQt5, fetchFromGitHub }:
let inherit libsForQt5 fetchFromGitHub;
in {
  nightly = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "1730";
    branchName = branch;
    branchDesc = "A Nintendo 3DS Emulator, this branch contains already reviewed and tested features";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "1a678gvl3dy7f7za8aj5g1p4bz62vy2x0whqc99sh1s6q07l91cy";
    };
  };
  canary = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "2001";
    branchName = branch;
    branchDesc = "A Nintendo 3DS Emulator, this branch contains additional features still under review";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "0zbm4nvjdprj4kyxqpas33ni0q5anxww4gvjw0mrw38ni3a1qlpw";
    };
  };
}.${branch}
