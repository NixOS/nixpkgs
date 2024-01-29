{ lib
, stdenv
, fetchFromGitHub
, python3
, wrapGAppsHook
, gobject-introspection
, glib
, gtk3
, qt5
, makeDesktopItem
, copyDesktopItems
, withCurses ? false
, withGTK ? false
, withQT ? false
}:
let
  mkDesktopItem = name: desktopName: comment: terminal: makeDesktopItem {
    inherit name desktopName comment terminal;
    icon = "trackma";
    exec = name + " %u";
    type = "Application";
    categories = [ "Network" ];
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "trackma";
  version = "0.8.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "z411";
    repo = "trackma";
    rev = "v${version}";
    sha256 = "qlkFQSJFjxkGd5WkNGfyAo64ys8VJLep/ZOL6icXQ4c=";
    fetchSubmodules = true; # for anime-relations submodule
  };

  nativeBuildInputs = [ copyDesktopItems python3.pkgs.poetry-core ]
    ++ lib.optionals withGTK [ wrapGAppsHook gobject-introspection ]
    ++ lib.optionals withQT [ qt5.wrapQtAppsHook ];

  buildInputs = lib.optionals withGTK [ glib gtk3 ];

  propagatedBuildInputs = with python3.pkgs; ([ requests ]
    ++ lib.optionals withQT [ pyqt5 ]
    ++ lib.optionals withGTK [ pycairo pygobject3 ]
    ++ lib.optionals withCurses [ urwid ]
    ++ lib.optionals stdenv.isLinux [ pydbus pyinotify ]
    ++ lib.optionals (withGTK || withQT) [ pillow ]);

  dontWrapQtApps = true;
  dontWrapGApps = true;

  preFixup = lib.optional withQT "wrapQtApp $out/bin/trackma-qt"
    ++ lib.optional withGTK "wrapGApp $out/bin/trackma-gtk";

  desktopItems = lib.optional withQT (mkDesktopItem "trackma-qt" "Trackma (Qt)" "Trackma Updater (Qt-frontend)" false)
    ++ lib.optional withGTK (mkDesktopItem "trackma-gtk" "Trackma (GTK)" "Trackma Updater (Gtk-frontend)" false)
    ++ lib.optional withCurses (mkDesktopItem "trackma-curses" "Trackma (ncurses)" "Trackma Updater (ncurses frontend)" true);

  postInstall = ''
    install -Dvm444 $src/trackma/data/icon.png $out/share/pixmaps/trackma.png
  '';

  doCheck = false;

  pythonImportsCheck = [ "trackma" ];

  postDist = lib.optional (!withQT) "rm $out/bin/trackma-qt"
    ++ lib.optional (!withGTK) "rm $out/bin/trackma-gtk"
    ++ lib.optional (!withCurses) "rm $out/bin/trackma-curses";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/z411/trackma";
    description = "Open multi-site list manager for Unix-like systems (ex-wMAL)";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
