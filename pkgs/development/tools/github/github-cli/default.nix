{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "github-cli-${version}";

  version = (import gemset).github_cli.version;
  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "CLI-based access to GitHub API v3";
    homepage    = https://github.com/piotrmurach/github_cli;
    license     = with licenses; apsl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
