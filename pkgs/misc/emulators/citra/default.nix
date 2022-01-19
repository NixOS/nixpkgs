{ branch ? "nightly", libsForQt5, fetchFromGitHub }:
{
  nightly = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "1742";
    branchName = branch;
    branchDesc = "A Nintendo 3DS Emulator, this branch contains already reviewed and tested features";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "4sdiDmqvOP8GH8luxhikS8N0DR/AEC1dgcA5pCzlPsw=";
      fetchSubmodules = true;
    };
  };
  canary = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "2019";
    branchName = branch;
    branchDesc = "A Nintendo 3DS Emulator, this branch contains additional features still under review";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "btHcctjeoibg6lbAv8LZ9h/vjJnzeWCgiYosnNUJkUs=";
      fetchSubmodules = true;
    };
  };
}.${branch}
