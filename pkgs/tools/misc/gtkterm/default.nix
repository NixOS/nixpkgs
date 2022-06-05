{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, gtk3, vte, libgudev, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gtkterm";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Jeija";
    repo = "gtkterm";
    rev = "${version}";
    sha256 = "0s2cx8w1n8d37pl80gll5h6dyvbqrfcam8l4wmvnqqww9jml6577";
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
