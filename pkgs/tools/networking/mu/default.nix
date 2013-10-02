{ fetchurl, stdenv, sqlite, pkgconfig, xapian, glib, gmime, texinfo, emacs, guile
, gtk3, webkit, libsoup, icu }:

stdenv.mkDerivation rec {
  version = "0.9.9.5";
  name = "mu-${version}";

  src = fetchurl {
    url = "https://mu0.googlecode.com/files/mu-${version}.tar.gz";
    sha256 = "1hwkliyb8fjrz5sw9fcisssig0jkdxzhccw0ld0l9a10q1l9mqhp";
  };

  buildInputs = [ sqlite pkgconfig xapian glib gmime texinfo emacs guile
                  gtk3 webkit libsoup icu ];

  preBuild = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-meta.el.in \
      --replace "@abs_top_builddir@" "$out"

    # We install msg2pdf to bin/msg2pdf, fix its location in elisp
    substituteInPlace mu4e/mu4e-actions.el \
      --replace "/toys/msg2pdf/msg2pdf" "/bin/msg2pdf"
  '';

  # Install mug and msg2pdf
  postInstall = ''
    cp -v toys/msg2pdf/msg2pdf $out/bin/
    cp -v toys/mug/mug $out/bin/
  '';

  meta = {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = "GPLv3+";
    homepage = "http://www.djcbsoftware.nl/code/mu/";
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ antono the-kenny ];
  };
}
