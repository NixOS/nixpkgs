{ stdenv, fetchFromGitHub, autoreconfHook, ncurses, libevent, pkgconfig, makeWrapper }:

let

  bashCompletion = fetchFromGitHub {
    owner = "przepompownia";
    repo = "tmux-bash-completion";
    rev = "678a27616b70c649c6701cae9cd8c92b58cc051b";
    sha256 = "1d2myrh4xiay9brsxafb02pi922760sdkyyy5xjm4sfh4iimc4zf";
  };

in

stdenv.mkDerivation rec {
  name = "tmux-${version}";
  version = "2.3";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = version;
    sha256 = "14c6iw0p3adz7w8jm42w9f3s1zph9is10cbwdjgh5bvifrhxrary";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ ncurses libevent makeWrapper ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    cp -v ${bashCompletion}/completions/tmux $out/share/bash-completion/completions/tmux
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
    maintainers = with stdenv.lib.maintainers; [ thammers fpletz ];
  };
}
