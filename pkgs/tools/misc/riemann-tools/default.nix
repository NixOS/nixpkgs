{ bundlerEnv }:

bundlerEnv {
  name = "riemann-tools-0.2.6";
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
}
