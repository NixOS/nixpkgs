{ lib, stdenv, mkDiscoursePlugin, fetchFromGitHub }:

 mkDiscoursePlugin {
  bundlerEnvArgs.gemdir = ./.;
  name = "discourse-prometheus";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-prometheus";
    rev = "31ae7c3c4daab543c63cd74e20b07f440d36fece";
    sha256 = "sha256-/wY/piUerXxQyhwqqqK4nWR9Qs6JAgEPIJ9Sw3yyDv0=";
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
