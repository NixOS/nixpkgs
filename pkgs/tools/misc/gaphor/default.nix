{ lib
, buildPythonApplication
, fetchFromGitHub
, copyDesktopItems
, gobject-introspection
, poetry-core
, wrapGAppsHook
, gtksourceview5
, libadwaita
, pango
, babel
, better-exceptions
, defusedxml
, gaphas
, generic
, jedi
, pillow
, pycairo
, pydot
, pygit2
, pygobject3
, tinycss2
, gtk4
, librsvg
, makeDesktopItem
, python
, hypothesis
, ipython
, pytest-archon
, sphinx
, xdoctest
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "2.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaphor";
    repo = "gaphor";
    rev = version;
    hash = "sha256-ZSKhDKEgexQe4XLQrZUIZNCdOR55FFuF6XfJhktobXw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    # Needed to load namespaces
    gobject-introspection
    poetry-core
    wrapGAppsHook
  ];

  buildInputs = [
    # Adds Gtk4 namespace
    gtksourceview5
    # Adds Adw namespace
    libadwaita
    # Adds Pango namespace
    pango
  ];

  propagatedBuildInputs = [
    babel
    better-exceptions
    defusedxml
    gaphas
    generic
    jedi
    pillow
    pycairo
    pydot
    pygit2
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
      --prefix XDG_DATA_DIRS : "${gtk4}/share/gsettings-schemas/${gtk4.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    )
  '';

  checkInputs = [
    hypothesis
    ipython
    pytest-archon
    sphinx
    xdoctest
    pytestCheckHook
  ];

  # Throws a segmentation fault
  doCheck = false;

  meta = with lib; {
    description = "Simple modeling tool written in Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/gaphor";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
