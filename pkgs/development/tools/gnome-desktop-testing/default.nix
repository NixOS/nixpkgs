{ lib, stdenv
, glib
, autoreconfHook
, pkg-config
, systemd
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "gnome-desktop-testing";
  version = "unstable-2019-12-11";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-desktop-testing";
    rev = "57239dc8ef49ba74d442603a07a3e132b0cfdc6a";
    sha256 = "01c4jhpk23kfcnw3l9kfwjw9v5kgqmfhhqypw4k2d2sdkf4mgfv4";
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

  meta = with lib; {
    description = "GNOME test runner for installed tests";
    homepage = "https://wiki.gnome.org/Initiatives/GnomeGoals/InstalledTests";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jtojnar ];
  };
}
