{ lib, stdenv, fetchFromGitHub, sqlite, pkg-config, autoreconfHook, pmccabe
, xapian, glib, gmime3, texinfo , emacs, guile
, gtk3, webkitgtk, libsoup, icu
, withMug ? false
, batchSize ? null }:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.4.15";

  src = fetchFromGitHub {
    owner  = "djcb";
    repo   = "mu";
    rev    = version;
    sha256 = "sha256-VIUA0W+AmEbvGWatv4maBGILvUTGhBgO3iQtjIc3vG8=";
  };

  postPatch = lib.optionalString (batchSize != null) ''
    sed -i lib/mu-store.cc --regexp-extended \
      -e 's@(constexpr auto BatchSize).*@\1 = ${toString batchSize};@'
  '';

  buildInputs = [
    sqlite xapian glib gmime3 texinfo emacs libsoup icu
  ]
    # Workaround for https://github.com/djcb/mu/issues/1641
    ++ lib.optional (!stdenv.isDarwin) guile
    ++ lib.optionals withMug [ gtk3 webkitgtk ];

  nativeBuildInputs = [ pkg-config autoreconfHook pmccabe ];

  enableParallelBuilding = true;

  preBuild = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-meta.el.in \
      --replace "@abs_top_builddir@" "$out"
  '';

  # Install mug
  postInstall = lib.optionalString withMug ''
    for f in mug ; do
      install -m755 toys/$f/$f $out/bin/$f
    done
  '';

  doCheck = true;

  meta = with lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/${version}";
    maintainers = with maintainers; [ antono peterhoeg ];
    platforms = platforms.mesaPlatforms;
  };
}
