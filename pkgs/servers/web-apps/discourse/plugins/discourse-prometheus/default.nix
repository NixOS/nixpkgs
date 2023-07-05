{ lib, stdenv, mkDiscoursePlugin, fetchFromGitHub }:

 mkDiscoursePlugin {
  bundlerEnvArgs.gemdir = ./.;
  name = "discourse-prometheus";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-prometheus";
    rev = "802cb5aa89838ecb3078dbe21b70d87b1675d89e";
    sha256 = "sha256-tgujK/k/7l/9dAFna5sfUpgP0PVfjk+aGRbqZ70lmRw=";
  };

  patches = [
    # The metrics collector tries to run git to get the commit id but fails
    # because we don't run Discourse from a Git repository.
    ./no-git-version.patch
    ./spec-import-fix-abi-version.patch
  ];

  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-prometheus";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Official Discourse Plugin for Prometheus Monitoring";
  };
}
