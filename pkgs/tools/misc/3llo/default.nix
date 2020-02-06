{ lib, ruby, bundlerApp, fetchpatch }:

bundlerApp {
  pname = "3llo";

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;

  gemset = lib.recursiveUpdate (import ./gemset.nix) ({
    "3llo" = {
      dontBuild = false;
      patches = [
        (fetchpatch {
          url = https://github.com/qcam/3llo/commit/7667c67fdc975bac315da027a3c69f49e7c06a2e.patch;
          sha256 = "0ahp19igj77x23b2j9zk3znlmm7q7nija7mjgsmgqkgfbz2r1y7v";
        })
      ];
    };
  });

  inherit ruby;

  exes = [ "3llo" ];

  meta = with lib; {
    description = "Trello interactive CLI on terminal";
    license = licenses.mit;
    homepage = https://github.com/qcam/3llo;
    maintainers = with maintainers; [ ];
  };
}
