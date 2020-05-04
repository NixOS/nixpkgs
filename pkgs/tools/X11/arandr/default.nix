{ stdenv, fetchurl, python3Packages
, gobject-introspection, gsettings-desktop-schemas, gtk3
, wrapGAppsHook, xrandr
}:

let
  inherit (python3Packages) buildPythonApplication docutils pygobject3;
  pname = "arandr";
  version = "0.1.10";
  name = "${pname}-${version}";
in buildPythonApplication rec {
  inherit pname version;

  src = fetchurl {
    url = "https://christian.amsuess.com/tools/arandr/files/${name}.tar.gz";
    sha256 = "135q0llvm077jil2fr92ssw3p095m4r8jfj0lc5rr3m71n4srj6v";
  };

  patchPhase = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  buildInputs = [ docutils gsettings-desktop-schemas gtk3 ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = [ xrandr pygobject3 ];

  meta = {
    homepage = "http://christian.amsuess.com/tools/arandr/";
    description = "A simple visual front end for XRandR";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
  };
}
