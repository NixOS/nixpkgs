{ lib
, buildPythonApplication
, fetchPypi
, copyDesktopItems
, gobject-introspection
, poetry-core
, wrapGAppsHook
, gtksourceview4
, pango
, gaphas
, generic
, jedi
, pycairo
, pygobject3
, tinycss2
, gtk3
, librsvg
, makeDesktopItem
, python
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "2.8.2";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+qqsSLjdY2I19fxdfkOEQ9DhTTHccUDll4O5yqtLiz0=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    poetry-core
    wrapGAppsHook
  ];

  buildInputs = [
    gtksourceview4
    pango
  ];

  propagatedBuildInputs = [
    gaphas
    generic
    jedi
    pycairo
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

  # Disable automatic wrapGAppsHook to prevent double wrapping
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
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/gaphor";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
