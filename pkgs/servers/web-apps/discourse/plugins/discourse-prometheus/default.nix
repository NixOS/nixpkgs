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
    rev = "14d2328911c3b7ed5b38c4713c52cd835793be5a";
    sha256 = "sha256-GpNh+7091Lj0JW+RB9EOgxFNOCkFVvpPd0vbbpFcvcE=";
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
