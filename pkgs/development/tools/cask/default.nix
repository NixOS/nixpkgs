{ stdenv, fetchurl, emacs, python }:

stdenv.mkDerivation rec {
  name = "cask-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "https://github.com/cask/cask/archive/v${version}.tar.gz";
    sha256 = "02f8bb20b33b23fb11e7d2a1d282519dfdb8b3090b9672448b8c2c2cacd3e478";
  };

  doCheck = true;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/templates
    install -Dm644 *.el $out/
    install -Dm755 bin/cask $out/bin
    install -Dm644 templates/* $out/templates/
    touch $out/.no-upgrade
    mkdir -p $out/usr/share/emacs/site-lisp/cask
    ln -s cask{,-bootstrap}.el $out/usr/share/emacs/site-lisp/cask/
  '';

  meta = with stdenv.lib; {
    description = "Project management for Emacs";
    longDescription = ''
      Cask is a project management tool for Emacs that helps automate the
      package development cycle; development, dependencies, testing, building,
      packaging and more.
      Cask can also be used to manage dependencies for your local Emacs configuration.
    '';

    homepage = https://cask.readthedocs.io/en/latest/index.html;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.flexw ];
  };

  nativeBuildInputs = [ emacs python ];
}
