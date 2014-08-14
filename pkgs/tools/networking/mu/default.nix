{ fetchurl, stdenv, sqlite, pkgconfig, autoconf, automake
, xapian, glib, gmime, texinfo , emacs, guile
, gtk3, webkit, libsoup, icu, withMug ? false /* doesn't build with current gtk3 */ }:

stdenv.mkDerivation rec {
  version = "0.9.9.6";
  name = "mu-${version}";

  src = fetchurl {
    url = "https://github.com/djcb/mu/archive/v${version}.tar.gz";
    sha256 = "1jr9ss29yi6d62hd4ap07p2abgf12hwqfhasv3gwdkrx8dzwmr2a";
  };

  buildInputs =
    [ sqlite pkgconfig autoconf automake xapian
      glib gmime texinfo emacs guile libsoup icu ]
    ++ stdenv.lib.optional withMug [ gtk3 webkit ];

  preConfigure = ''
    autoreconf -i
  '';

  preBuild = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-meta.el.in \
      --replace "@abs_top_builddir@" "$out"

    # We install msg2pdf to bin/msg2pdf, fix its location in elisp
    substituteInPlace mu4e/mu4e-actions.el \
      --replace "/toys/msg2pdf/msg2pdf" "/bin/msg2pdf"
  '';

  # Install mug and msg2pdf
  postInstall = stdenv.lib.optionalString withMug ''
    cp -v toys/msg2pdf/msg2pdf $out/bin/
    cp -v toys/mug/mug $out/bin/
  '';

  meta = {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = "http://www.djcbsoftware.nl/code/mu/";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = with stdenv.lib.maintainers; [ antono the-kenny ];
  };
}
