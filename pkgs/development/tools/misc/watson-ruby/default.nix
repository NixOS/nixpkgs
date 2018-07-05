{ wrapCommand, lib, bundlerEnv, ruby }:

let
  env = bundlerEnv {
    name = "watson-ruby-gems";
    inherit ruby;
    # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
    gemdir = ./.;
  };
in wrapCommand "watson" {
  inherit (env.gems.watson-ruby) version;
  executable = "${env}/bin/watson";
  meta = with lib; {
    description = "An inline issue manager";
    homepage    = http://goosecode.com/watson/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ robertodr ];
    platforms   = platforms.unix;
  };
}
