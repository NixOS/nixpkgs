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
  version = "unstable-2021-12-28";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "1eeb3538b2a71addd0d8adc9f53ffe80fdfb8ce0";
    sha256 = "sha256-u2VJIDc1yvhbBgdMKL1RijoKEL4Vl8sbrGUYu5t/wJI=";
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
