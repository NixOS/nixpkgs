{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  bundlerEnvArgs.gemdir = ./.;
  name = "discourse-prometheus";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-prometheus";
    rev = "12424c2e48551c5503fe2424b27aed0f34da0730";
    sha256 = "sha256-1i3nPtGIFHVFxhfRxHqnmyJf0xpulXacOpz+29yLm3Q=";
  };

  patches = [
    # The metrics collector tries to run git to get the commit id but fails
    # because we don't run Discourse from a Git repository.
    ./no-git-version.patch
    ./spec-import-fix-abi-version.patch
  ];

  meta = {
    homepage = "https://github.com/discourse/discourse-prometheus";
    license = lib.licenses.mit;
    description = "Official Discourse Plugin for Prometheus Monitoring";
  };
}
