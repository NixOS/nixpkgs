{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, coreutils
, emacs
, glib
, gmime3
, texinfo
, xapian
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.10.8";

  outputs = [ "out" "mu4e" ];

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "v${version}";
    hash = "sha256-cDfW0yXA+0fZY5lv4XCHWu+5B0svpMeVMf8ttX/z4Og=";
  };

  patches = [
    (fetchpatch {
      name = "add-mu4e-pkg.el";
      url = "https://github.com/djcb/mu/commit/00f7053d51105eea0c72151f1a8cf0b6d8478e4e.patch";
      hash = "sha256-21c7djmYTcqyyygqByo9vu/GsH8WMYcq8NOAvJsS5AQ=";
    })
  ];

  postPatch = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-config.el.in \
      --replace "@abs_top_builddir@" "$out"
    substituteInPlace lib/utils/mu-test-utils.cc \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  postInstall = ''
    rm --verbose $mu4e/share/emacs/site-lisp/mu4e/*.elc
  '';

  # move only the mu4e info manual
  # this has to be after preFixup otherwise the info manual may be moved back by _multioutDocs()
  # we manually move the mu4e info manual instead of setting
  # outputInfo to mu4e because we do not want to move the mu-guile
  # info manual (if it exists)
  postFixup = ''
    moveToOutput share/info/mu4e.info.gz $mu4e
    install-info $mu4e/share/info/mu4e.info.gz $mu4e/share/info/dir
    if [[ -a ''${!outputInfo}/share/info/mu-guile.info.gz ]]; then
      install-info --delete $mu4e/share/info/mu4e.info.gz ''${!outputInfo}/share/info/dir
    else
      rm --verbose --recursive ''${!outputInfo}/share/info
    fi
  '';

  buildInputs = [ emacs glib gmime3 texinfo xapian ];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
    "-Dlispdir=${placeholder "mu4e"}/share/emacs/site-lisp"
  ];

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  meta = with lib; {
    description = "A collection of utilities for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/v${version}";
    maintainers = with maintainers; [ antono chvp peterhoeg ];
    mainProgram = "mu";
    platforms = platforms.unix;
  };
}
