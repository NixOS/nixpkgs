{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "t-3.1.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A command-line power tool for Twitter";
    homepage    = http://sferik.github.io/t/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
