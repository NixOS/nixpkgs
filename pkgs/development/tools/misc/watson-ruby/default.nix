{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "watson-ruby-${version}";

  version = (import ./gemset.nix).watson-ruby.version;
  inherit ruby;
  # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
  gemdir = ./.;

  meta = with lib; {
    description = "An inline issue manager";
    homepage    = http://goosecode.com/watson/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ robertodr ];
    platforms   = platforms.unix;
  };
}
