{ stdenv, fetchurl
, coreutils, gnused, getopt, pwgen, git, tree, gnupg
, makeWrapper

, xclip ? null, xdotool ? null, dmenu ? null
, x11Support ? true
}:

assert x11Support -> xclip != null
                  && xdotool != null
                  && dmenu != null;

stdenv.mkDerivation rec {
  version = "1.6.5";
  name    = "password-store-${version}";

  src = fetchurl {
    url    = "http://git.zx2c4.com/password-store/snapshot/${name}.tar.xz";
    sha256 = "05bk3lrp5jwg0v338lvylp7glpliydzz4jf5pjr6k3kagrv3jyik";
  };

  patches = if stdenv.isDarwin then [ ./no-darwin-getopt.patch ] else null;

  buildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = http://zx2c4.com/projects/password-store/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 the-kenny ];
    platforms   = platforms.unix;

    longDescription = ''
      pass is a very simple password store that keeps passwords inside gpg2
      encrypted files inside a simple directory tree residing at
      ~/.password-store. The pass utility provides a series of commands for
      manipulating the password store, allowing the user to add, remove, edit,
      synchronize, generate, and manipulate passwords.
    '';
  };

  preInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    mkdir -p "$out/share/zsh/site-functions"
    mkdir -p "$out/share/fish/completions"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    # Install Emacs Mode. NOTE: We can't install the necessary
    # dependencies (s.el and f.el) here. The user has to do this
    # himself.
    mkdir -p "$out/share/emacs/site-lisp"
    cp "contrib/emacs/password-store.el" "$out/share/emacs/site-lisp/"

    ${if x11Support then ''
      cp "contrib/dmenu/passmenu" "$out/bin/"
    '' else ""}
  '';

  postFixup = ''
    # Fix program name in --help
    substituteInPlace $out/bin/pass \
      --replace "\$program" "pass"

    # Ensure all dependencies are in PATH
    wrapProgram $out/bin/pass \
      --prefix PATH : "${coreutils}/bin:${gnused}/bin:${getopt}/bin:${gnupg}/bin:${git}/bin:${tree}/bin:${pwgen}/bin${if x11Support then ":${xclip}/bin" else ""}"

    ${if x11Support then ''
      wrapProgram $out/bin/passmenu \
        --prefix PATH : "$out/bin:${xdotool}/bin:${dmenu}/bin"
    '' else ""}
  '';
}
