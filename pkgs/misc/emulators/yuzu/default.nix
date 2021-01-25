{ branch ? "mainline", pkgs }:
let
  inherit (pkgs) libsForQt5 fetchFromGitHub;
in {
  mainline = libsForQt5.callPackage ./base.nix rec {
    pname = "yuzu-mainline";
    version = "517";
    branch = branch;
    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "0i73yl2ycs8p9cqn25rw35cll0l6l68605f1mc1qvf4zy82jggbb";
      fetchSubmodules = true;
    };
  };
}.${branch}
