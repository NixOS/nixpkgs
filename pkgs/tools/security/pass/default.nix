{ stdenv, lib, fetchurl
, coreutils, gnused, getopt, git, tree, gnupg, which, procps, qrencode
, makeWrapper

, xclip ? null, xdotool ? null, dmenu ? null
, x11Support ? !stdenv.isDarwin
}:

with lib;

assert x11Support -> xclip != null
                  && xdotool != null
                  && dmenu != null;

stdenv.mkDerivation rec {
  version = "1.7.1";
  name    = "password-store-${version}";

  src = fetchurl {
    url    = "http://git.zx2c4.com/password-store/snapshot/${name}.tar.xz";
    sha256 = "0scqkpll2q8jhzcgcsh9kqz0gwdpvynivqjmmbzax2irjfaiklpn";
  };

  patches = [ ./set-correct-program-name-for-sleep.patch
            ] ++ stdenv.lib.optional stdenv.isDarwin ./no-darwin-getopt.patch;

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=$(out)" "WITH_ALLCOMP=yes" ];

  postInstall = ''
    # Install Emacs Mode. NOTE: We can't install the necessary
    # dependencies (s.el and f.el) here. The user has to do this
    # himself.
    mkdir -p "$out/share/emacs/site-lisp"
    cp "contrib/emacs/password-store.el" "$out/share/emacs/site-lisp/"
  '' + optionalString x11Support ''
    cp "contrib/dmenu/passmenu" "$out/bin/"
  '';

  wrapperPath = with stdenv.lib; makeBinPath ([
    coreutils
    getopt
    git
    gnupg
    gnused
    tree
    which
    qrencode
  ] ++ stdenv.lib.optional stdenv.isLinux procps
    ++ ifEnable x11Support [ dmenu xclip xdotool ]);

  postFixup = ''
    # Fix program name in --help
    substituteInPlace $out/bin/pass \
      --replace 'PROGRAM="''${0##*/}"' "PROGRAM=pass"

    # Ensure all dependencies are in PATH
    wrapProgram $out/bin/pass \
      --prefix PATH : "${wrapperPath}"
  '' + stdenv.lib.optionalString x11Support ''
    # We just wrap passmenu with the same PATH as pass. It doesn't
    # need all the tools in there but it doesn't hurt either.
    wrapProgram $out/bin/passmenu \
      --prefix PATH : "$out/bin:${wrapperPath}"
  '';

  meta = with stdenv.lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = http://www.passwordstore.org/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 the-kenny fpletz ];
    platforms   = platforms.unix;

    longDescription = ''
      pass is a very simple password store that keeps passwords inside gpg2
      encrypted files inside a simple directory tree residing at
      ~/.password-store. The pass utility provides a series of commands for
      manipulating the password store, allowing the user to add, remove, edit,
      synchronize, generate, and manipulate passwords.
    '';
  };
}
