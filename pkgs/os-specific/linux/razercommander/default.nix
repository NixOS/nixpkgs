{ lib
, meson
, ninja
, pkg-config
, fetchFromGitLab
, python3
, wrapGAppsHook
, gtk3
, glib
, desktop-file-utils
, gobject-introspection
}:

python3.pkgs.buildPythonApplication rec {
  pname = "razerCommander";
  version = "1.2.1.2";

  format = "other";

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "razerCommander";
    rev = version;
    sha256 = "NiLKui1GfEqb5MfsWZ9SYuwLQLCf67sn8tMKy9yk3mw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib # for glib-compile-schemas
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    gobject-introspection.setupHook
  ];

  buildInputs = [
    gtk3
    glib
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    openrazer
  ];

  # Work around setup hook issues https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  postPatch = ''
    substituteInPlace razercommander/__main__.py \
      --replace plugdev openrazer
  '';

  meta = with lib; {
    description = "GTK contol center for managing razer peripherals on Linux";
    homepage = "https://gitlab.com/gabmus/razerCommander";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
