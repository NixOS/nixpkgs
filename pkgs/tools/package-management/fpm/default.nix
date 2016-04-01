{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "fpm-${version}";

  version = (import gemset).fpm.version;
  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Tool to build packages for multiple platforms with ease";
    homepage    = https://github.com/jordansissel/fpm;
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
