{ lib
, fetchurl
, python3Packages
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, wrapGAppsHook
, xrandr
}:

let
  inherit (python3Packages) buildPythonApplication docutils pygobject3;
in
buildPythonApplication rec {
  pname = "arandr";
  version = "0.1.10";

  src = fetchurl {
    url = "https://christian.amsuess.com/tools/arandr/files/${pname}-${version}.tar.gz";
    sha256 = "135q0llvm077jil2fr92ssw3p095m4r8jfj0lc5rr3m71n4srj6v";
  };

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [ docutils gsettings-desktop-schemas gtk3 ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = [ xrandr pygobject3 ];

  meta = {
    homepage = "https://christian.amsuess.com/tools/arandr/";
    description = "A simple visual front end for XRandR";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.domenkozar ];
  };
}
