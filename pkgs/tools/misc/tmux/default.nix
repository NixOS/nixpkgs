{ stdenv, fetchurl, ncurses, libevent, pkgconfig }:

stdenv.mkDerivation rec {
  name = "tmux-${version}";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/tmux/tmux/releases/download/${version}/${name}.tar.gz";
    sha256 = "0qnkda8kb747vmbldjpb23ksv9pq3s65xhh1ja5rdsmh8r24npvr";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ ncurses libevent ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    cp -v examples/bash_completion_tmux.sh $out/etc/bash_completion.d/tmux
  '';

  meta = {
    homepage = http://tmux.github.io/;
    description = "Terminal multiplexer";

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
    maintainers = with stdenv.lib.maintainers; [ shlevy thammers ];
  };
}
