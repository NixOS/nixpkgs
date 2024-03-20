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
  version = "unstable-2023-05-28";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tartan";
    repo = "tartan";
    rev = "a4387a49c7bb318121a89f9042a28b4bbbec0720";
    sha256 = "0pXZiju4OhDf9+G0t1KRafRZXVZlkTLKyAhBkyCWAk0=";
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
    maintainers = with maintainers; [ jtojnar ];
  };
}
