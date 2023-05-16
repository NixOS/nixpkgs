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
<<<<<<< HEAD
  version = "0.8.6";
  format = "pyproject";
=======
  version = "0.8.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "z411";
    repo = "trackma";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "qlkFQSJFjxkGd5WkNGfyAo64ys8VJLep/ZOL6icXQ4c=";
    fetchSubmodules = true; # for anime-relations submodule
  };

  nativeBuildInputs = [ copyDesktopItems python3.pkgs.poetry-core ]
=======
    sha256 = "sha256-BjZw/AYFlTYtgJTDFOALHx1d71ZQsYZ2TXnEUeQVvpw=";
    fetchSubmodules = true; # for anime-relations submodule
  };

  nativeBuildInputs = [ copyDesktopItems ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optionals withGTK [ wrapGAppsHook gobject-introspection ]
    ++ lib.optionals withQT [ qt5.wrapQtAppsHook ];

  buildInputs = lib.optionals withGTK [ glib gtk3 ];

<<<<<<< HEAD
  propagatedBuildInputs = with python3.pkgs; ([ requests ]
    ++ lib.optionals withQT [ pyqt5 ]
    ++ lib.optionals withGTK [ pycairo pygobject3 ]
    ++ lib.optionals withCurses [ urwid ]
    ++ lib.optionals stdenv.isLinux [ pydbus pyinotify ]
=======
  propagatedBuildInputs = with python3.pkgs; ([ urllib3 ]
    ++ lib.optionals withQT [ pyqt5 ]
    ++ lib.optionals withGTK [ pycairo ]
    ++ lib.optionals withCurses [ urwid ]
    ++ lib.optionals stdenv.isLinux [ dbus-python pygobject3 pyinotify ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ WeebSorceress ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
