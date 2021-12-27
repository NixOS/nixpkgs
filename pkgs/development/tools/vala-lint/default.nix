{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "unstable-2021-11-18";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "2db018056befba76136e6c69a78d905a128a6165";
    sha256 = "sha256-bQaj2bETzl6ykgrpE2iLAvx691aGDLFteL/ulfoKuEk=";
  };

  patches = [
    # Fix build against vala-0.54.3+. Pull fix pending upstream
    # inclusion: https://github.com/vala-lang/vala-lint/pull/155
    (fetchpatch {
      name = "vala-0.54.patch";
      url = "https://github.com/vala-lang/vala-lint/commit/739f9a0b7d3e92db41eb32f2bfa527efdacc223b.patch";
      sha256 = "sha256-1IbQu3AQXRCrrjoMZKhEOqzExmPAo1SQOFHa/IrqnNA=";
    })
  ];

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
