{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "compass-1.0.3";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain";
    homepage    = https://github.com/Compass/compass;
    license     = with licenses; mit;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
