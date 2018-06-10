{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "cucumber-${version}";

  version = (import gemset).cucumber.version;
  inherit ruby;
  # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A tool for executable specifications";
    homepage    = https://cucumber.io/;
    license     = with licenses; mit;
    platforms   = platforms.unix;
  };
}
