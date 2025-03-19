{
  lib,
  buildPythonApplication,
  fetchPypi,
  copyDesktopItems,
  gobject-introspection,
  poetry-core,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  pango,
  gaphas,
  generic,
  jedi,
  pycairo,
  pillow,
  dulwich,
  pydot,
  defusedxml,
  better-exceptions,
  babel,
  pygobject3,
  tinycss2,
  gtk4,
  librsvg,
  makeDesktopItem,
  python,
  nix-update-script,
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5n0XeZLQw4qje6gwh2aMu5Zo5tuXgESHhkR0xegaYM=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "gaphas"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtksourceview5
    pango
    libadwaita
  ];

  build-system = [ poetry-core ];

  dependencies = [
    babel
    better-exceptions
    defusedxml
    dulwich
    gaphas
    generic
    jedi
    pillow
    pycairo
    pydot
    pygobject3
    tinycss2
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "gaphor";
      icon = "gaphor";
      comment = meta.description;
      desktopName = "Gaphor";
    })
  ];

  # Disable automatic wrapGAppsHook4 to prevent double wrapping
  dontWrapGApps = true;

  postInstall = ''
    install -Dm644 $out/${python.sitePackages}/gaphor/ui/icons/hicolor/scalable/apps/org.gaphor.Gaphor.svg $out/share/pixmaps/gaphor.svg
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk4}/share/gsettings-schemas/${gtk4.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple modeling tool written in Python";
    homepage = "https://github.com/gaphor/gaphor";
    changelog = "https://github.com/gaphor/gaphor/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ ] ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
}
