{ stdenv, fetchFromGitHub, sqlite, pkgconfig, autoreconfHook, pmccabe
, xapian, glib, gmime3, texinfo , emacs, guile
, gtk3, webkitgtk, libsoup, icu
, withMug ? false
, batchSize ? null }:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner  = "djcb";
    repo   = "mu";
    rev    = version;
    sha256 = "1l8c72f3yd2vypc11frsmjnkr87h1q4gb6k3armpypwv6a6zl8z4";
  };

  postPatch = stdenv.lib.optionalString (batchSize != null) ''
    sed -i lib/mu-store.cc --regexp-extended \
      -e 's@(constexpr auto BatchSize).*@\1 = ${toString batchSize};@'
  '';

  buildInputs = [
    sqlite xapian glib gmime3 texinfo emacs libsoup icu
  ]
    # Workaround for https://github.com/djcb/mu/issues/1641
    ++ stdenv.lib.optional (!stdenv.isDarwin) guile
    ++ stdenv.lib.optionals withMug [ gtk3 webkitgtk ];

  nativeBuildInputs = [ pkgconfig autoreconfHook pmccabe ];

  enableParallelBuilding = true;

  preBuild = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-meta.el.in \
      --replace "@abs_top_builddir@" "$out"
  '';

  # Install mug
  postInstall = stdenv.lib.optionalString withMug ''
    for f in mug ; do
      install -m755 toys/$f/$f $out/bin/$f
    done
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/${version}";
    maintainers = with maintainers; [ antono peterhoeg ];
    platforms = platforms.mesaPlatforms;
  };
}
