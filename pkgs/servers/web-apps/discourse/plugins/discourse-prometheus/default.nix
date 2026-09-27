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
    rev = "8850b2ee1acb69266f8697c3741f34cca80cad61";
    sha256 = "sha256-7koWRb0ifMwHdtpjV6X4yTiKmK7zVCdIJlewkY5Vgzs=";
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
