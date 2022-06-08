{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, bison
, libevent
, ncurses
, pkg-config
, systemd
, utf8proc
}:

let

  bashCompletion = fetchFromGitHub {
    owner = "imomaliev";
    repo = "tmux-bash-completion";
    rev = "f5d53239f7658f8e8fbaf02535cc369009c436d6";
    hash = "sha256-Od+mIceN94q4R7Tt8ueDwZUF2Ui8YY6NcrMOCPh4Ams=";
  };

in
stdenv.mkDerivation rec {
  pname = "tmux";
  version = "3.3";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = version;
    hash = "sha256-Sxj2vXkbbPNRrqJKeIYwI7xdBtwRbl6a6a3yZr7UWW0=";
  };

  patches = [
    # https://github.com/tmux/tmux/issues/3206
    (fetchpatch {
      url = "https://github.com/tmux/tmux/commit/18838fbc877b5c003449fa10df353405c024f0f5.patch";
      hash = "sha256-OX1EDYiJyzAG6Znn8rRX+TxQ42rY3bMogtpHKKj3g6U=";
      name = "fix_segfault_with_v3_3.patch";
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
  ] ++ lib.optionals stdenv.isLinux [ systemd ]
  ++ lib.optionals stdenv.isDarwin [ utf8proc ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ lib.optionals stdenv.isLinux [ "--enable-systemd" ]
  ++ lib.optionals stdenv.isDarwin [ "--enable-utf8proc" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    cp -v ${bashCompletion}/completions/tmux $out/share/bash-completion/completions/tmux
  '';

  meta = {
    homepage = "https://tmux.github.io/";
    description = "Terminal multiplexer";
    longDescription = ''
      tmux is intended to be a modern, BSD-licensed alternative to programs such as GNU screen. Major features include:
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
    maintainers = with lib.maintainers; [ thammers fpletz SuperSandro2000 ];
  };
}
