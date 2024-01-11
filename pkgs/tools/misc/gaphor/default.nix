{ lib
, buildPythonApplication
, fetchPypi
, copyDesktopItems
, gobject-introspection
, poetry-core
, wrapGAppsHook
, gtksourceview5
, pango
, gaphas
, generic
, jedi
, pycairo
, pygobject3
, tinycss2
, gtk4
, libadwaita
, librsvg
, makeDesktopItem
, python
, python3Packages
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "2.23.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/JvWvzNprY8CsMBeLPdMR4WEZa6OUhUv2TdgZI5kpos=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    poetry-core
    wrapGAppsHook
  ];

  buildInputs = [
    gtksourceview5
    pango
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = [
    gaphas
    generic
    jedi
    pycairo
    pygobject3
    tinycss2
    python3Packages.defusedxml
  ];

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "gaphor";
    icon = "gaphor";
    comment = meta.description;
    desktopName = "Gaphor";
  };

  # Disable automatic wrapGAppsHook to prevent double wrapping
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

  meta = with lib; {
    description = "Simple modeling tool written in Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/gaphor";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
