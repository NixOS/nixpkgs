{ lib
, buildPythonApplication
, fetchPypi
, poetry-core
, gobject-introspection
, pango
, gtksourceview4
, wrapGAppsHook
, makeDesktopItem
, copyDesktopItems
, gaphas
, generic
, pycairo
, pygobject3
, python
, tinycss2
}:

buildPythonApplication rec {
  pname = "gaphor";
  version = "2.6.5";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IFsbWx5lblKsnEibVihM6ZPRoydXC+JM1gdZEUUTKxw=";
  };

  nativeBuildInputs = [
    poetry-core copyDesktopItems gobject-introspection wrapGAppsHook
  ];

  # Setting gobject-introspection on booth nativeBuildInputs and
  # buildInputs because of #56943. This recognizes pango, avoiding
  # a "ValueError: Namespace PangoCairo not available".
  buildInputs = [ gobject-introspection gtksourceview4 pango ];

  propagatedBuildInputs = [
    gaphas
    generic
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

  postInstall = ''
    install -Dm644 $out/${python.sitePackages}/gaphor/ui/icons/hicolor/scalable/apps/org.gaphor.Gaphor.svg $out/share/pixmaps/gaphor.svg
  '';

  meta = with lib; {
    description = "Simple modeling tool written in Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/gaphor";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
