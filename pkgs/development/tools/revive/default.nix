{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "revive";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xZakVuw+QKzFh6wsnZbltLEEwyb9WcMvVWEzKnS9aWc=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" "+%Y-%m-%d %H:%M UTC" > $out/DATE
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };
  vendorSha256 = "sha256-Fpl5i+qMvJ/CDh8X0gps9C/BxF7/Uvln+3DpVOXE0WQ=";

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
  # $ nix log /nix/store/build-revive.1.2.1.drv | grep FAIL
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
