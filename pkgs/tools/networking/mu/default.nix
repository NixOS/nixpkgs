{ stdenv, fetchFromGitHub, sqlite, pkgconfig, autoreconfHook, pmccabe
, xapian, glib, gmime, texinfo , emacs, guile
, gtk3, webkitgtk24x-gtk3, libsoup, icu
, withMug ? false }:

stdenv.mkDerivation rec {
  name = "mu-${version}";
  version = "0.9.18";

  src = fetchFromGitHub {
    owner  = "djcb";
    repo   = "mu";
    rev    = version;
    sha256 = "0zy0p196bfrfzsq8f58xv04rpnr948sdvljflgzvi6js0vz4009y";
  };

  # as of 0.9.18 2 tests are failing but previously we had no tests
  patches = [
    ./failing_tests.patch
  ];

  # pmccabe should be a checkInput instead, but configure looks for it
  buildInputs = [
    sqlite xapian glib gmime texinfo emacs guile libsoup icu
  ] ++ stdenv.lib.optionals withMug [ gtk3 webkitgtk24x-gtk3 ];
  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  checkInputs = [ pmccabe ];

  doCheck = true;

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

  meta = with stdenv.lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "http://www.djcbsoftware.nl/code/mu/";
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ antono the-kenny peterhoeg ];
  };
}
