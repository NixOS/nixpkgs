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
, wrapGAppsHook3
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "vala-lint";
  version = "0-unstable-2023-12-05";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "8ae2bb65fe66458263d94711ae4ddd978faece00";
    sha256 = "sha256-FZV726ZeNEX4ulEh+IIzwZqpnVRr7IeZb47FV1C7YjU=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
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
