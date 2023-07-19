{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, gtk3, vte, libgudev, wrapGAppsHook, pcre2 }:

stdenv.mkDerivation rec {
  pname = "gtkterm";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Jeija";
    repo = "gtkterm";
    rev = version;
    sha256 = "sha256-4Z+8fs4VEk2+Ci1X3oUuInylTdIbQ5AiPenFqnyNXvc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    vte
    libgudev
    pcre2
  ];

  meta = with lib; {
    description = "A simple, graphical serial port terminal emulator";
    homepage = "https://github.com/Jeija/gtkterm";
    license = licenses.gpl3Plus;
    longDescription = ''
      GTKTerm is a simple, graphical serial port terminal emulator for
      Linux and possibly other POSIX-compliant operating systems. It
      can be used to communicate with all kinds of devices with a
      serial interface, such as embedded computers, microcontrollers,
      modems, GPS receivers, CNC machines and more.
    '';
    maintainers = with maintainers; [ wentasah ];
    platforms = platforms.linux;
    mainProgram = "gtkterm";
  };
}
