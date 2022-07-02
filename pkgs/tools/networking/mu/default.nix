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
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "v${version}";
    sha256 = "wpyolNXm5JloKMJarYzSbs2yMcrkl73vOw6951Ol8Rs=";
  };

  postPatch = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-config.el.in \
      --replace "@abs_top_builddir@" "$out"
    substituteInPlace lib/utils/mu-utils.cc \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  buildInputs = [ emacs glib gmime3 texinfo xapian ];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
  ];

  nativeBuildInputs = [ pkg-config meson ninja ];

  enableParallelBuilding = true;

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
