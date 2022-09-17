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
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "z411";
    repo = "trackma";
    rev = "v${version}";
    sha256 = "sha256-drc39ID4WYBQ/L2py57CB5OkQNfRKNigPQW0Lp8GIMc=";
    fetchSubmodules = true; # for anime-relations submodule
  };

  nativeBuildInputs = [ copyDesktopItems ]
    ++ lib.optionals withGTK [ wrapGAppsHook ]
    ++ lib.optionals withQT [ qt5.wrapQtAppsHook ];

  buildInputs = lib.optionals withGTK [ glib gobject-introspection gtk3 ];

  propagatedBuildInputs = with python3.pkgs; ([ urllib3 ]
    ++ lib.optionals withQT [ pyqt5 ]
    ++ lib.optionals withGTK [ pycairo ]
    ++ lib.optionals withCurses [ urwid ]
    ++ lib.optionals stdenv.isLinux [ dbus-python pygobject3 pyinotify ]
    ++ lib.optionals (withGTK || withQT) [ pillow ]);

  # broken with gobject-introspection setup hook, see https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

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
    maintainers = with maintainers; [ WeebSorceress ];
  };
}
