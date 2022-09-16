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
}:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.8.10";

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "v${version}";
    hash = "sha256-hwroSuxn9zVjQBz8r2y93o42zzVkHWAZaEKKEVgSb5s=";
  };

  postPatch = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-config.el.in \
      --replace "@abs_top_builddir@" "$out"
    substituteInPlace lib/utils/mu-test-utils.cc \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  buildInputs = [ emacs glib gmime3 texinfo xapian ];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
  ];

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  meta = with lib; {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/v${version}";
    maintainers = with maintainers; [ antono chvp peterhoeg ];
    platforms = platforms.unix;
  };
}
