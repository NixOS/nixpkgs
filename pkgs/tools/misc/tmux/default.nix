{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, bison
, ncurses
, libevent
, utf8proc
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
  version = "3.2a";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = version;
    sha256 = "0143ylfk7zsl3xmiasb768238gr582cfhsgv3p0h0f13bp8d6q09";
  };

  patches = [
    # See https://github.com/tmux/tmux/pull/2755
    (fetchpatch {
      url = "https://github.com/tmux/tmux/commit/d0a2683120ec5a33163a14b0e1b39d208745968f.patch";
      sha256 = "070knpncxfxi6k4q64jwi14ns5vm3606cf402h1c11cwnaa84n1g";
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
  ] ++ lib.optionals stdenv.isDarwin [ utf8proc ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ lib.optionals stdenv.isDarwin [ "--enable-utf8proc" ];

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
