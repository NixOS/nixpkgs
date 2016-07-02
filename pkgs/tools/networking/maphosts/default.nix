{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "maphosts-1.1.1";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Small command line application for keeping your project hostnames in sync with /etc/hosts";
    homepage    = https://github.com/mpscholten/maphosts;
    license     = licenses.mit;
    maintainers = with maintainers; [ mpscholten ];
    platforms   = platforms.all;
  };
}
