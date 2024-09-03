{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
, libxkbcommon
, cairo
, gdk-pixbuf
, scdoc
}:

stdenv.mkDerivation {
  pname = "waylogout";
  version = "unstable-2023-06-09";

  src = fetchFromGitHub {
    owner = "loserMcloser";
    repo = "waylogout";
    rev = "f90e1b8b0f67a2694fafca7beb32828493f3f78e";
    hash = "sha256-YQtX4t6q2NybuKU3lVcn5XhC0nXcPfEbcXbuFmDZOrw=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
    gdk-pixbuf
  ];

  meta = with lib; {
    description = "Graphical logout/suspend/reboot/shutdown dialog for wayland";
    homepage = "https://github.com/loserMcloser/waylogout";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "waylogout";
  };
}
