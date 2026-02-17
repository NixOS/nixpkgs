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
    rev = "9da0e79ef30544a626bc65c3697ef5c9005b01d2";
    sha256 = "sha256-jq2tFzNshYZQRpiKsENB5dnKSlBgTjBQpMd4CPu7LIU=";
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
