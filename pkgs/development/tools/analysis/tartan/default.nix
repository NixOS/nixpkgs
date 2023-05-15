{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, llvmPackages_16
, gobject-introspection
, glib
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "tartan";
  version = "unstable-2023-05-15";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tartan";
    repo = "tartan";
    rev = "6757cd29b5a33cf9496664cb03c6f4e61f150f19";
    sha256 = "f3I12zjkF7pfVCE+TTJMWh3Jg6fHFwjDcp2AWtmTpao=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gobject-introspection
    glib
    llvmPackages_16.libclang
    llvmPackages_16.libllvm
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      # The updater tries src.url by default, which does not exist for fetchFromGitLab (fetchurl).
      url = "https://gitlab.freedesktop.org/tartan/tartan.git";
    };

    llvmPackages = llvmPackages_16;
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
