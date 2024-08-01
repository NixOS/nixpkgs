{ lib
, fetchurl
, python3Packages
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, wrapGAppsHook3
, xrandr
}:

let
  inherit (python3Packages) buildPythonApplication docutils pygobject3;
in
buildPythonApplication rec {
  pname = "arandr";
  version = "0.1.11";

  src = fetchurl {
    url = "https://christian.amsuess.com/tools/arandr/files/${pname}-${version}.tar.gz";
    hash = "sha256-5Mu+Npi7gSs5V3CHAXS+AJS7rrOREFqBH5X0LrGCrgI=";
  };

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [ docutils gsettings-desktop-schemas gtk3 ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook3 ];
  propagatedBuildInputs = [ xrandr pygobject3 ];

  meta = with lib; {
    homepage = "https://christian.amsuess.com/tools/arandr/";
    description = "Simple visual front end for XRandR";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gepbird ];
    mainProgram = "arandr";
  };
}
