{ fetchurl, stdenv, ncurses, pkgconfig, emacs}:

stdenv.mkDerivation rec {
  name = "cscope-15.7a";

  src = fetchurl {
    url = "mirror://sourceforge/cscope/${name}.tar.bz2";
    sha256 = "0dv0r66x31y2xxvad54x0wal8yb1krwbx3gjc82qpg4hlz5qnqq2";
  };

  preConfigure = ''
    sed -i "contrib/xcscope/cscope-indexer" \
        -"es|^PATH=.*$|PATH=\"$out/bin:\$PATH\"|g"
    sed -i "contrib/xcscope/xcscope.el" \
        -"es|\"cscope-indexer\"|\"$out/libexec/cscope/cscope-indexer\"|g";
  '';

  configureFlags = "--with-ncurses=${ncurses}";

  buildInputs = [ ncurses pkgconfig emacs ];

  postInstall = ''
    # Install Emacs mode.
    cd "contrib/xcscope"

    ensureDir "$out/libexec/cscope"
    cp "cscope-indexer" "$out/libexec/cscope"

    ensureDir "$out/share/emacs/site-lisp"
    emacs --batch --eval '(byte-compile-file "xcscope.el")'
    cp xcscope.el{,c} "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "Cscope, a developer's tool for browsing source code";

    longDescription = ''
      Cscope is a developer's tool for browsing source code.  It has
      an impeccable Unix pedigree, having been originally developed at
      Bell Labs back in the days of the PDP-11.  Cscope was part of
      the official AT&T Unix distribution for many years, and has been
      used to manage projects involving 20 million lines of code!
    '';

    license = "BSD-style";

    homepage = http://cscope.sourceforge.net/;

    maintainers = with stdenv.lib.maintainers; [viric];

    platforms = with stdenv.lib.platforms; linux;
  };
}
