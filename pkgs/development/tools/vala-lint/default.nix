{ stdenv
, fetchFromGitHub
, glib
, meson
, ninja
, pantheon
, pkgconfig
, vala
, gettext
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "vala-lint-unstable";
  version = "2020-08-18";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "fc5dd9e95bc61540b404d5bc070c0629903baad9";
    sha256 = "n6pp6vYGaRF8B3phWp/e9KnpKGf0Op+xGVdT6HHe0rM=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
  ];

  # See https://github.com/vala-lang/vala-lint/issues/133
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/vala-lang/vala-lint";
    description = "Check Vala code files for code-style errors";
    longDescription = ''
      Small command line tool and library for checking Vala code files for code-style errors.
      Based on the elementary Code-Style guidelines.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
