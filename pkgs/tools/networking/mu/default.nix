{ fetchurl, stdenv, sqlite, pkgconfig, autoreconfHook
, xapian, glib, gmime, texinfo , emacs, guile
, gtk3, webkitgtk24x, libsoup, icu
, withMug ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  version = "0.9.18";
  name = "mu-${version}";

  src = fetchurl {
    url = "https://github.com/djcb/mu/archive/${version}.tar.gz";
    sha256 = "0gfwi4dwqhsz138plryd0j935vx2i44p63jpfx85ki3l4ysmmlwd";
  };

  buildInputs = [
    sqlite pkgconfig xapian glib gmime texinfo emacs guile libsoup icu
    autoreconfHook ] ++ stdenv.lib.optionals withMug [ gtk3 webkitgtk24x ];

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

  meta = with stdenv.lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "http://www.djcbsoftware.nl/code/mu/";
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ antono the-kenny ];
  };
}
