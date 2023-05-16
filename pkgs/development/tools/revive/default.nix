{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "revive";
<<<<<<< HEAD
  version = "1.3.3";
=======
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+ac/Sq+4Ox/R3N7cMM+QADWf9jZJwYJEOvHDdkB5X9Q=";
=======
    sha256 = "sha256-Iqe3iFE9hTPUgIO6MoPHAkr+KU5mEJ3ZY4Oh9xhXido=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" "+%Y-%m-%d %H:%M UTC" > $out/DATE
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };
<<<<<<< HEAD
  vendorHash = "sha256-00w07PgPf+4eclxx6/fY9SbmOEU8FPxIOmg/i9NBboM=";
=======
  vendorHash = "sha256-FHm4TjsAYu4VM2WAHdd2xPP3/54YM6ei6cppHWF8LDc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mgechev/revive/cli.version=${version}"
    "-X github.com/mgechev/revive/cli.builtBy=nix"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/mgechev/revive/cli.commit=$(cat COMMIT)"
    ldflags+=" -X 'github.com/mgechev/revive/cli.date=$(cat DATE)'"
  '';

  # The following tests fail when built by nix:
  #
<<<<<<< HEAD
  # $ nix log /nix/store/build-revive.1.3.3.drv | grep FAIL
=======
  # $ nix log /nix/store/build-revive.1.3.1.drv | grep FAIL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  #
  # --- FAIL: TestAll (0.01s)
  # --- FAIL: TestTimeEqual (0.00s)
  # --- FAIL: TestTimeNaming (0.00s)
  # --- FAIL: TestUnhandledError (0.00s)
  # --- FAIL: TestUnhandledErrorWithBlacklist (0.00s)
  doCheck = false;

  meta = with lib; {
    description = "Fast, configurable, extensible, flexible, and beautiful linter for Go";
    homepage = "https://revive.run";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
  };
}
