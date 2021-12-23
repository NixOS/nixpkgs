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
}:

stdenv.mkDerivation rec {
  pname = "vala-lint-unstable";
  version = "2021-02-17";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "5b06cc2341ae7e9f7f8c35c542ef78c36e864c30";
    sha256 = "KwJ5sCp9ZrrxIqc6qi2+ZdHBt1esNOO1+uDkS+d9mW8=";
  };

  patches = [
    # Fix build against vala-0.54+. Pull fix pending upstream
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
  };
}
