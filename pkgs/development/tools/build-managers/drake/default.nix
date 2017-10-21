{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "drake-0.9.2.0.3.1";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
  
  meta = with lib; {
    description = "A branch of Rake supporting automatic parallelizing of tasks";
    homepage = http://quix.github.io/rake/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
