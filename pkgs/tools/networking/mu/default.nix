{ stdenv, fetchFromGitHub, sqlite, pkgconfig, autoreconfHook, pmccabe
, xapian, glib, gmime, texinfo , emacs, guile
, gtk3, webkitgtk24x-gtk3, libsoup, icu
, withMug ? false }:

stdenv.mkDerivation rec {
  name = "mu-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner  = "djcb";
    repo   = "mu";
    rev    = "v${version}";
    sha256 = "0y6azhcmqdx46a9gi7mn8v8p0mhfx2anjm5rj7i69kbr6j8imlbc";
  };

  # 0.9.18 and 1.0 have 2 failing tests but previously we had no tests
  patches = [
    ./failing_tests.patch
  ];

  # test-utils coredumps so don't run those
  postPatch = ''
    sed -i -e '/test-utils/d' lib/parser/Makefile.am
  '';

  buildInputs = [
    sqlite xapian glib gmime texinfo emacs guile libsoup icu
  ] ++ stdenv.lib.optionals withMug [ gtk3 webkitgtk24x-gtk3 ];

  nativeBuildInputs = [ pkgconfig autoreconfHook pmccabe ];

  enableParallelBuilding = true;

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
    for f in msg2pdf mug ; do
      install -m755 toys/$f/$f $out/bin/$f
    done
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = http://www.djcbsoftware.nl/code/mu/;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ antono the-kenny peterhoeg ];
  };
}
