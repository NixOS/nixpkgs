{ stdenv, fetchFromGitHub, autoreconfHook, ncurses, libevent, pkgconfig, makeWrapper }:

let

  bashCompletion = fetchFromGitHub {
    owner = "imomaliev";
    repo = "tmux-bash-completion";
    rev = "fcda450d452f07d36d2f9f27e7e863ba5241200d";
    sha256 = "092jpkhggjqspmknw7h3icm0154rg21mkhbc71j5bxfmfjdxmya8";
  };

in

stdenv.mkDerivation rec {
  pname = "tmux";
  version = "2.9";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "191y986k9q17fdxlh3ldkr81s8fpxj4n2lc2lys6hzi4ybrhgdik";
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
