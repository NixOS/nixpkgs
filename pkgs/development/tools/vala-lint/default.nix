{ lib
, stdenv
, fetchFromGitHub
, glib
, json-glib
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
  version = "unstable-2023-11-12";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "95cf9e61a73fe4a0f69fd8c275c9548703f79838";
    sha256 = "sha256-w5jW/JM1sR9gIIVl3WJNK9jpaA4CMr56Wt4AuxUlkW8=";
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
    json-glib
  ];

  postPatch = ''
    # https://github.com/vala-lang/vala-lint/issues/181
    substituteInPlace test/meson.build \
      --replace "test('auto-fix', auto_fix_test, env: test_envars)" ""
  '';

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
