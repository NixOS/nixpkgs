{ lib
, babel
, better-exceptions
, buildPythonApplication
, copyDesktopItems
, defusedxml
, dulwich
, fetchPypi
, gaphas
, generic
, gobject-introspection
, gtk3
, gtksourceview5
, jedi
, libadwaita
, librsvg
, makeDesktopItem
, pango
, pillow
, poetry-core
, pycairo
, pydot
, pygobject3
, python
, tinycss2
, wrapGAppsHook4
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "2.25.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9PNgU1/9RL6QXba0gn4zHCAtSV3iY0HOY1Rf6bkyzxY=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    poetry-core
    wrapGAppsHook4
  ];

  buildInputs = [
    gtksourceview5
    pango
  ];

  propagatedBuildInputs = [
    babel
    better-exceptions
    defusedxml
    dulwich
    gaphas
    generic
    jedi
    libadwaita
    pillow
    pycairo
    pydot
    pygobject3
    tinycss2
  ];

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "gaphor";
    icon = "gaphor";
    comment = meta.description;
    desktopName = "Gaphor";
  };

  # Disable automatic wrapGAppsHook3 to prevent double wrapping
  dontWrapGApps = true;

  postInstall = ''
    install -Dm644 $out/${python.sitePackages}/gaphor/ui/icons/hicolor/scalable/apps/org.gaphor.Gaphor.svg $out/share/pixmaps/gaphor.svg
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    )
  '';

  meta = with lib; {
    description = "Simple modeling tool written in Python";
    maintainers = [ ];
    homepage = "https://github.com/gaphor/gaphor";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
