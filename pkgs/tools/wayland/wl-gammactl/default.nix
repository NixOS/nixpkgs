{ lib, stdenv, fetchFromGitHub
, meson, pkg-config, ninja
, wayland, wayland-scanner, wlr-protocols, gtk3, glib
}:

stdenv.mkDerivation rec {
  pname = "wl-gammactl";
  version = "unstable-2021-09-13";

  src = fetchFromGitHub {
    owner = "mischw";
    repo = pname;
    rev = "e2385950d97a3baf1b6e2f064dd419ccec179586";
    sha256 = "8iMJK4O/sNIGPOBZQEfK47K6OjT6sxYFe19O2r/VSr8=";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson pkg-config ninja glib wayland-scanner ];
  buildInputs = [ wayland gtk3 ];

  postUnpack = ''
    rmdir source/wlr-protocols
    ln -s ${wlr-protocols}/share/wlr-protocols source
  '';

  patches = [ ./dont-need-wlroots.diff ];

  postPatch = ''
    substituteInPlace meson.build --replace "git = find_program('git')" "git = 'false'"
  '';

  meta = with lib; {
    description = "Contrast, brightness, and gamma adjustments for Wayland";
    longDescription = ''
      Small GTK GUI application to set contrast, brightness, and gamma for wayland compositors which
      support the wlr-gamma-control protocol extension.
    '';
    homepage = "https://github.com/mischw/wl-gammactl";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lodi ];
    mainProgram = "wl-gammactl";
  };
}
