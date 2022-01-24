{ branch, libsForQt5, fetchFromGitHub }:

{
  nightly = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "1747";
    branchDesc = "A Nintendo 3DS Emulator, this branch contains already reviewed and tested features";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "sha256-WBqsIlymPEVtGmGqgsXkoGJtTofiTLqB3c2z1l/8hXE=";
      fetchSubmodules = true;
    };
  };
  canary = libsForQt5.callPackage ./base.nix rec {
    pname = "citra-${branch}";
    version = "2031";
    branchDesc = "A Nintendo 3DS Emulator, this branch contains additional features still under review";
    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = pname;
      rev = "${branch}-${version}";
      sha256 = "sha256-oEg3bMq/vzx77XAflwewALaIoQyHlyCRpFRDjx7ScVg=";
      fetchSubmodules = true;
    };
  };
}.${branch}
