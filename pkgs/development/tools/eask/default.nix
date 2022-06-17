{ lib, stdenv, python3, emacs, bash }:

stdenv.mkDerivation rec {
  pname = "eask";

  src = fetchgit {
    url = "https://github.com/emacs-eask/eask.git";
    rev = "e91e3f159eeae640b6a69617e520d8c5c9d084ed";
    sha256 = "1d24234qrnb8787m9rrdalyg5ksrqri1i5p6wx1wai8crrm7k80j";
  };
  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    emacs --batch -L . -f batch-byte-compile cask.el cask-cli.el

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    dir=$out/share/emacs/site-lisp/cask
    install -Dm444 -t $dir     *.el *.elc
    install -Dm555 -t $dir/bin bin/eask
    touch $out/.no-upgrade
    ln -s $dir/bin/eask $out/bin/eask

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line tool for building and testing Emacs Lisp packages";
    longDescription = ''
      Eask is a command-line tool that helps you build, lint, and test Emacs
	  Lisp packages. It creates a clean environment to sandbox your elisp code
	  without influencing your personal configuration.
    '';

    homepage = "https://emacs-eask.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jcs090218 ];
    platforms = platforms.all;
  };
}
