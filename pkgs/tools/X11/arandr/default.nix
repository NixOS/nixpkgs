{ lib
, fetchurl
, fetchFromGitLab
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
  version = "0.1.11";

  src = fetchFromGitLab {
    owner = "${pname}";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "sha256-nQtfOKAnWKsy2DmvtRGJa4+Y9uGgX41BeHpd9m4d9YA=";
  };

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [ docutils gsettings-desktop-schemas gtk3 ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = [ xrandr pygobject3 ];

  meta = with lib; {
    homepage = "https://christian.amsuess.com/tools/arandr/";
    description = "A simple visual front end for XRandR";
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar itcger ];
  };
}
