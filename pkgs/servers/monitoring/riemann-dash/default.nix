{ bundlerEnv }:

bundlerEnv {
  name = "riemann-dash-0.2.9";
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
}
