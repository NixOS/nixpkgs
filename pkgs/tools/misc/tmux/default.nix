{stdenv, fetchurl, ncurses, libevent}:

stdenv.mkDerivation rec {
  pname = "tmux";
  version = "1.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "72c2d6f1c30fb4ccbd29b530a7d8a08e67c9c2d87ac8d67e3806561670fc0362";
  };

  makeFlags = "PREFIX=\${out}";

  crossAttrs = {
    preBuild = ''
      makeFlags=" $makeFlags CC=${stdenv.cross.config}-gcc "
    '';
  };

  buildInputs = [ ncurses libevent ];

  meta = {
    homepage = http://tmux.sourceforge.net/;
    description = "tmux is a terminal multiplexer";

    longDescription =
      '' tmux is intended to be a modern, BSD-licensed alternative to programs such as GNU screen. Major features include:

          * A powerful, consistent, well-documented and easily scriptable command interface.
          * A window may be split horizontally and vertically into panes.
          * Panes can be freely moved and resized, or arranged into preset layouts.
          * Support for UTF-8 and 256-colour terminals.
          * Copy and paste with multiple buffers.
          * Interactive menus to select windows, sessions or clients.
          * Change the current window by searching for text in the target.
          * Terminal locking, manually or after a timeout.
          * A clean, easily extended, BSD-licensed codebase, under active development. 
      '';

    license = stdenv.lib.licenses.bsd3;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thammers ];
  };
}
