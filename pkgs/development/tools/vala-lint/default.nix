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
  version = "2019-10-11";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "a077bbec30dea128616a23583ce3f8364ff2ef11";
    sha256 = "0w0rmaj4v42wc4vq2lfjnj6airag5ahv6522xkw3j1nmccxq3s72";
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
    homepage = https://github.com/vala-lang/vala-lint;
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
