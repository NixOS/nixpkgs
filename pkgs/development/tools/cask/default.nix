{ stdenv, fetchurl, python, emacsPackages }:

stdenv.mkDerivation rec {
  pname = "cask";
  version = "0.8.4";

  src = fetchurl {
    url = "https://github.com/cask/cask/archive/v${version}.tar.gz";
    sha256 = "02f8bb20b33b23fb11e7d2a1d282519dfdb8b3090b9672448b8c2c2cacd3e478";
  };

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
    mkdir -p $out/share/emacs/site-lisp/cask/templates
    mkdir -p $out/share/emacs/site-lisp/cask/bin
    install -Dm644 *.el *.elc $out/share/emacs/site-lisp/cask
    install -Dm755 bin/cask $out/share/emacs/site-lisp/cask/bin
    install -Dm644 templates/* $out/share/emacs/site-lisp/cask/templates/
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
