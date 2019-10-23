{ stdenv, fetchFromGitHub, sqlite, pkgconfig, autoreconfHook, pmccabe
, xapian, glib, gmime3, texinfo , emacs, guile
, gtk3, webkitgtk24x-gtk3, libsoup, icu
, withMug ? false }:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner  = "djcb";
    repo   = "mu";
    rev    = version;
    sha256 = "1g7rhgp405v7q9xx44k6jn3py4v73a9qjwhai6l459wdywdz1n3n";
  };

  # test-utils coredumps so don't run those
  postPatch = ''
    sed -i -e '/test-utils/d' lib/parser/Makefile.am
  '';

  buildInputs = [
    sqlite xapian glib gmime3 texinfo emacs guile libsoup icu
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
    homepage = https://www.djcbsoftware.nl/code/mu/;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ antono the-kenny peterhoeg ];
  };
}
