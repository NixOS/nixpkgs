{ fetchurl, stdenv, ncurses
, emacsSupport ? true, emacs
}:

stdenv.mkDerivation rec {
  name = "cscope-15.9";

  src = fetchurl {
    url = "mirror://sourceforge/cscope/${name}.tar.gz";
    sha256 = "0ngiv4aj3rr35k3q3wjx0y19gh7i1ydqa0cqip6sjwd8fph5ll65";
  };

  configureFlags = [ "--with-ncurses=${ncurses.dev}" ];

  buildInputs = [ ncurses ];
  nativeBuildInputs = stdenv.lib.optional emacsSupport emacs;

  postInstall = stdenv.lib.optionalString emacsSupport ''
    cd "contrib/xcscope"

    sed -i "cscope-indexer" \
        -"es|^PATH=.*$|PATH=\"$out/bin:\$PATH\"|g"
    sed -i "xcscope.el" \
        -"es|\"cscope-indexer\"|\"$out/libexec/cscope/cscope-indexer\"|g";

    mkdir -p "$out/libexec/cscope"
    cp "cscope-indexer" "$out/libexec/cscope"

    mkdir -p "$out/share/emacs/site-lisp"
    emacs --batch --eval '(byte-compile-file "xcscope.el")'
    cp xcscope.el{,c} "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "A developer's tool for browsing source code";

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

    platforms = stdenv.lib.platforms.unix;
  };
}
