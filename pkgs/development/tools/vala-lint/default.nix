{ lib
, stdenv
, fetchFromGitHub
, glib
, meson
, ninja
, pantheon
, pkg-config
, vala
, gettext
, wrapGAppsHook
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "vala-lint";
  version = "unstable-2022-05-20";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "b5c22b3bce25837565a894ba1a91bc856b60c251";
    sha256 = "sha256-DzK4CihXUOY3xnVnuCgfFmhN+Q3gUD/v77vA7hS9qWE=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/vala-lang/vala-lint.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/vala-lang/vala-lint";
    description = "Check Vala code files for code-style errors";
    longDescription = ''
      Small command line tool and library for checking Vala code files for code-style errors.
      Based on the elementary Code-Style guidelines.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.vala-lint";
  };
}
