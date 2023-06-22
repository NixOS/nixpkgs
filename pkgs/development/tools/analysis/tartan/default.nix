{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, llvmPackages
, gobject-introspection
, glib
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "tartan";
  version = "unstable-2021-12-23";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tartan";
    repo = "tartan";
    rev = "bd4ea95d8b3ce1258491e9fac7fcc37d2b241a16";
    sha256 = "l3duPt8Kh/JljzOV+Dm26XbS7gZ+mmFfYUYofWSJRyo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gobject-introspection
    glib
    llvmPackages.libclang
    llvmPackages.libllvm
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      # The updater tries src.url by default, which does not exist for fetchFromGitLab (fetchurl).
      url = "https://gitlab.freedesktop.org/tartan/tartan.git";
    };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Tools and Clang plugins for developing code with GLib";
    homepage = "https://freedesktop.org/wiki/Software/tartan";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
