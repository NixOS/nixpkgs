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
<<<<<<< HEAD
  version = "unstable-2023-05-25";
=======
  version = "unstable-2022-09-15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
<<<<<<< HEAD
    rev = "4d21b8a2be8b77052176d06d0cf10a8b319117c4";
    sha256 = "sha256-OnBeiYm83XjAezHEBEA2LvJ5ErVOyKclXJcS0cYaLIg=";
=======
    rev = "923adb5d3983ed654566304284607e3367998e22";
    sha256 = "sha256-AHyc6jJyEPfUON7yf/6O2jfcnRD3fW2R9UfIsx2Zmdc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
