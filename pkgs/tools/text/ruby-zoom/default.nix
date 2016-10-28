{ lib, bundlerEnv, ruby, stdenv }:

bundlerEnv {
  pname = "ruby-zoom";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Quickly open CLI search results in your favorite editor!";
    homepage    = https://gitlab.com/mjwhitta/zoom;
    license     = with licenses; gpl3;
    maintainers = with stdenv.lib.maintainers; [ vmandela ];
    platforms   = platforms.unix;
  };
}
