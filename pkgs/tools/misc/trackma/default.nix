{ lib
, stdenv
, fetchFromGitHub
, python3
, wrapGAppsHook
, gobject-introspection
, glib
, gtk3
, withCurses ? false
, withGtk ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trackma";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "z411";
    repo = "trackma";
    rev = "v${version}";
    sha256 = "sha256-drc39ID4WYBQ/L2py57CB5OkQNfRKNigPQW0Lp8GIMc=";
  };

  nativeBuildInputs = lib.optionals withGtk [ wrapGAppsHook ];

  buildInputs = lib.optionals withGtk [ glib gobject-introspection gtk3 ];

  propagatedBuildInputs = [ python3.pkgs.urllib3  python3.pkgs.dbus-python ]
    ++ lib.optionals withGtk [ python3.pkgs.pillow python3.pkgs.pygobject3 python3.pkgs.pycairo ]
    ++ lib.optionals withCurses [ python3.pkgs.urwid ]
    ++ lib.optionals stdenv.isLinux [ python3.pkgs.pyinotify ];

  # broken with gobject-introspection setup hook, see https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  dontWrapGApps = true; # prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false;

  pythonImportsCheck = [ "trackma" ];

  # FIXME(trackma-qt): https://github.com/NixOS/nixpkgs/pull/179715#issuecomment-1171371059
  postDist = ''
    rm $out/bin/trackma-qt
    ${lib.optionalString (!withGtk) "rm $out/bin/trackma-gtk"}
    ${lib.optionalString (!withCurses) "rm $out/bin/trackma-curses"}
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/z411/trackma";
    description = "Open multi-site list manager for Unix-like systems (ex-wMAL)";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ WeebSorceress ];
  };
}
