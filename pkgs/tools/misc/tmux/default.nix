{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, bison
, ncurses
, libevent
}:

let

  bashCompletion = fetchFromGitHub {
    owner = "imomaliev";
    repo = "tmux-bash-completion";
    rev = "f5d53239f7658f8e8fbaf02535cc369009c436d6";
    sha256 = "0sq2g3w0h3mkfa6qwqdw93chb5f1hgkz5vdl8yw8mxwdqwhsdprr";
  };

in

stdenv.mkDerivation rec {
  pname = "tmux";
  version = "3.2";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = version;
    sha256 = "0alq81h1rz1f0zsy8qb2dvsl47axpa86j4bplngwkph0ksqqgr3p";
  };

  patches = [
    # Fix cross-compilation
    # https://github.com/tmux/tmux/pull/2651
    (fetchpatch {
      url = "https://github.com/tmux/tmux/commit/bb6242675ad0c7447daef148fffced882e5b4a61.patch";
      sha256 = "1acr3xv3gqpq7qa2f8hw7c4f42hi444lfm1bz6wqj8f3yi320zjr";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    bison
  ];

  buildInputs = [
    ncurses
    libevent
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    cp -v ${bashCompletion}/completions/tmux $out/share/bash-completion/completions/tmux
  '';

  meta = {
    homepage = "https://tmux.github.io/";
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
    changelog = "https://github.com/tmux/tmux/raw/${version}/CHANGES";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thammers fpletz ];
  };
}
