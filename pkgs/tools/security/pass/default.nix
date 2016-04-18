{ stdenv, fetchurl
, coreutils, gnused, getopt, pwgen, git, tree, gnupg, which
, makeWrapper

, xclip ? null, xdotool ? null, dmenu ? null
, x11Support ? !stdenv.isDarwin
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

  patches =
    [ ./program-name.patch ] ++
    stdenv.lib.optional stdenv.isDarwin ./no-darwin-getopt.patch;

  buildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = http://www.passwordstore.org/;
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
    mkdir -p "$out/share/fish/vendor_completions.d"
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

  wrapperPath = with stdenv.lib; makeBinPath ([
    coreutils
    gnused
    getopt
    git
    gnupg
    pwgen
    tree
    which
  ] ++ ifEnable x11Support [ dmenu xclip xdotool ]);

  postFixup = ''
    # Fix program name in --help
    substituteInPlace $out/bin/pass \
      --replace "\$program" "pass"

    # Ensure all dependencies are in PATH
    wrapProgram $out/bin/pass \
      --prefix PATH : "${wrapperPath}"
  '' + stdenv.lib.optionalString x11Support ''
    # We just wrap passmenu with the same PATH as pass. It doesn't
    # need all the tools in there but it doesn't hurt either.
    wrapProgram $out/bin/passmenu \
      --prefix PATH : "$out/bin:${wrapperPath}"
  '';
}
