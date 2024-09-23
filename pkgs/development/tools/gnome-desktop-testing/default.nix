{ stdenv
, lib
, glib
, autoreconfHook
, pkg-config
, systemd
, fetchFromGitLab
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "gnome-desktop-testing";
  version = "2021.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-desktop-testing";
    rev = "v${version}";
    sha256 = "sha256-PWn4eEZskY0YgMpf6O2dgXNSu8b8T311vFHREv2HE/Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    systemd
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GNOME test runner for installed tests";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-desktop-testing";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jtojnar ];
  };
}
