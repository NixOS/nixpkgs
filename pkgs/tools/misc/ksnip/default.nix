{ stdenv
, lib
, cmake
, extra-cmake-modules
, fetchFromGitHub
, kcolorpicker
, kimageannotator
, wrapQtAppsHook
, qtsvg
, qttools
, qtx11extras
}:

stdenv.mkDerivation rec {
  pname = "ksnip";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "ksnip";
    rev = "v${version}";
    sha256 = "sha256-n7YwDXd73hyrzb6L8utZFuHh9HnjVtkU6CC4jfWPj/I=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    kcolorpicker
    kimageannotator
    qtsvg
    qtx11extras
  ];

  meta = with lib; {
    homepage = "https://github.com/ksnip/ksnip";
    description = "Cross-platform screenshot tool with many annotation features";
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
