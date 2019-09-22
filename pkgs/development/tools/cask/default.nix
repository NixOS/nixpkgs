{ stdenv, fetchurl, python, emacsPackages }:

stdenv.mkDerivation rec {
  pname = "cask";

  inherit (emacsPackages.melpaStablePackages.cask) src version;

  doCheck = true;

  nativeBuildInputs = [ emacsPackages.emacs ];
  buildInputs = with emacsPackages; [
    s f dash ansi ecukes servant ert-runner el-mock
    noflet ert-async shell-split-string git package-build
  ] ++ [
    python
  ];

  buildPhase = ''
    emacs --batch -L . -f batch-byte-compile cask.el cask-cli.el
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/templates
    mkdir -p $out/share/emacs/site-lisp/cask/bin
    install -Dm644 *.el *.elc $out/share/emacs/site-lisp/cask
    install -Dm755 bin/cask $out/share/emacs/site-lisp/cask/bin
    install -Dm644 templates/* $out/templates/
    touch $out/.no-upgrade
    ln -s $out/share/emacs/site-lisp/cask/bin/cask $out/bin/cask
  '';

  meta = with stdenv.lib; {
    description = "Project management for Emacs";
    longDescription = ''
      Cask is a project management tool for Emacs that helps automate the
      package development cycle; development, dependencies, testing, building,
      packaging and more.
      Cask can also be used to manage dependencies for your local Emacs configuration.
    '';

    homepage = "https://cask.readthedocs.io/en/latest/index.html";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.flexw ];
  };
}
