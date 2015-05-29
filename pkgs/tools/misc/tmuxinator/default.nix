{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "tmuxinator-0.6.9";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Manage complex tmux sessions easily";
    homepage    = https://github.com/tmuxinator/tmuxinator;
    license     = licenses.mit;
    maintainers = with maintainers; [ auntie ];
    platforms   = platforms.unix;
  };
}
