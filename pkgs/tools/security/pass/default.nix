{ stdenv, fetchurl
, coreutils, gnused, getopt, pwgen, git, tree, gnupg
, makeWrapper
, withX ? false, xclip ? null
}:

assert withX -> xclip != null;

stdenv.mkDerivation rec {
  version = "1.6.2";
  name    = "password-store-${version}";

  src = fetchurl {
    url    = "http://git.zx2c4.com/password-store/snapshot/${name}.tar.xz";
    sha256 = "1d32y6k625pv704icmhg46zg02kw5zcyxscgljxgy8bb5wv4lv2j";
  };

  patches = [ ./darwin-getopt.patch ];

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

  installPhase = ''
    mkdir -p "$out/share/bash-completion/completions"
    mkdir -p "$out/share/zsh/site-functions"
    mkdir -p "$out/share/fish/completions"

    # Install Emacs Mode. NOTE: We can't install the necessary
    # dependencies (s.el and f.el) here. The user has to do this
    # himself.
    mkdir -p "$out/share/emacs/site-lisp"
    cp "contrib/emacs/password-store.el" "$out/share/emacs/site-lisp/"

    PREFIX="$out" make install
  '';

  postFixup = ''
    # Fix program name in --help
    substituteInPlace $out/bin/pass \
      --replace "\$program" "pass"

    # Ensure all dependencies are in PATH
    wrapProgram $out/bin/pass \
      --prefix PATH : "${coreutils}/bin:${gnused}/bin:${getopt}/bin:${gnupg}/bin:${git}/bin:${tree}/bin:${pwgen}/bin${if withX then ":${xclip}/bin" else ""}"
  '';
}
