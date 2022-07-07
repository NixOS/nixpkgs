{ lib
, buildPythonPackage
, fetchPypi
, pkg-config
, gobject-introspection
, pygobject3
, gtk3
, glib
}:

buildPythonPackage rec {
  pname = "gtkme";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NIUgnbfcHjbPfsH3CF2Bywo8owrdsi1wqDoMxOa+2U4=";
  };

  nativeBuildInputs = [ pkg-config gobject-introspection gtk3 ];
  buildInputs = [ pygobject3 glib ];
  propagatedBuildInputs = [ gtk3 ];

  pythonImportsCheck = [
    "gtkme"
  ];

  meta = with lib; {
    description = "Manages an Application with Gtk windows, forms, lists and other complex items easily";
    homepage = "https://gitlab.com/doctormo/gtkme";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      revol-xut
    ];
  };
}
