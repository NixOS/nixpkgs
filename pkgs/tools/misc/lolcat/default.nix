{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "lolcat-42.1.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Colorful 'cat'";
    homepage    = https://github.com/busyloop/lolcat;
    license     = stdenv.lib.licenses.wtfpl;
    maintainers = with stdenv.lib.maintainers; [ ikervagyok ];
  };
}
