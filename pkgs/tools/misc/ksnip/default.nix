{ stdenv
, lib
, autoPatchelfHook
, wrapQtAppsHook
, fetchurl
, dpkg
, qtbase
, qtx11extras
}:

stdenv.mkDerivation rec {
  pname = "ksnip";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/ksnip/ksnip/releases/download/v${version}/ksnip-${version}-continuous.deb";
    sha256 = "0wabyhb6751jlbrr0872ks2klb6570yfjczn6fjb1albavsk8mml";
  };

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $src .";

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    qtbase
    qtx11extras
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
    dpkg
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv usr $out/
    ln -s $out/usr/bin/ksnip $out/bin/ksnip
  '';

  meta = with lib; {
    homepage = "https://github.com/ksnip/ksnip";
    description = "Cross-platform screenshot tool wihth many annotation features";
    longDescription = ''
      Features:

      - Supports Linux (X11, Plasma Wayland, GNOME Wayland and xdg-desktop-portal Wayland), Windows and macOS.
      - Screenshot of a custom rectangular area that can be drawn with mouse cursor.
      - Screenshot of last selected rectangular area without selecting again.
      - Screenshot of the screen/monitor where the mouse cursor is currently located.
      - Screenshot of full-screen, including all screens/monitors.
      - Screenshot of window that currently has focus.
      - Screenshot of window under mouse cursor.
      - Screenshot with or without mouse cursor.
      - Capture mouse cursor as annotation item that can be moved and deleted.
      - Customizable capture delay for all capture options.
      - Upload screenshots directly to imgur.com in anonymous or user mode.
      - Upload screenshots via custom user defined scripts.
      - Command-line support, for capturing screenshots and saving to default location, filename and format.
      - Filename wildcards for Year ($Y), Month ($M), Day ($D), Time ($T) and Counter (multiple # characters for number with zero-leading padding).
      - Print screenshot or save it to PDF/PS.
      - Annotate screenshots with pen, marker, rectangles, ellipses, texts and other tools.
      - Annotate screenshots with stickers and add custom stickers.
      - Obfuscate image regions with blur and pixelate.
      - Add effects to image (Drop Shadow, Grayscale, invert color or Border).
      - Add watermarks to captured images.
      - Global hotkeys for capturing screenshots (currently only for Windows and X11).
      - Tabs for screenshots and images.
      - Open existing images via dialog, drag-and-drop or paste from clipboard.
      - Run as single instance application (secondary instances send cli parameter to primary instance).
      - Pin screenshots in frameless windows that stay atop other windows.
      - User-defined actions for taking screenshot and post-processing.
      - Many configuration options.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
