{ stdenv, fetchFromGitHub, sqlite, pkgconfig, autoreconfHook, pmccabe
, xapian, glib, gmime3, texinfo , emacs, guile
, gtk3, webkitgtk, libsoup, icu
, withMug ? false }:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.2";

  src = fetchFromGitHub {
    owner  = "djcb";
    repo   = "mu";
    rev    = version;
    sha256 = "0yhjlj0z23jw3cf2wfnl98y8q6gikvmhkb8vdm87bd7jw0bdnrfz";
  };

  # test-utils coredumps so don't run those
  postPatch = ''
    sed -i -e '/test-utils/d' lib/parser/Makefile.am
  '';

  buildInputs = [
    sqlite xapian glib gmime3 texinfo emacs guile libsoup icu
  ] ++ stdenv.lib.optionals withMug [ gtk3 webkitgtk ];

  nativeBuildInputs = [ pkgconfig autoreconfHook pmccabe ];

  enableParallelBuilding = true;

  preBuild = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-meta.el.in \
      --replace "@abs_top_builddir@" "$out"

    # We install msg2pdf to bin/msg2pdf, fix its location in elisp
    substituteInPlace mu4e/mu4e-actions.el \
      --replace "/toys/msg2pdf/" "/bin/"
  '';

  # Install mug and msg2pdf
  postInstall = stdenv.lib.optionalString withMug ''
    for f in msg2pdf mug ; do
      install -m755 toys/$f/$f $out/bin/$f
    done
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = https://www.djcbsoftware.nl/code/mu/;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ antono the-kenny peterhoeg ];
  };
}
