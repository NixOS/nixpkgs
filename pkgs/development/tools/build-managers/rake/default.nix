{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "rake-11.1.1";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
  
  meta = with lib; {
    description = "A software task management and build automation tool";
    homepage = https://github.com/ruby/rake;
    license  = with licenses; mit;
    platforms = platforms.unix;
  };
}
