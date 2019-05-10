{ stdenv, fetchurl, gobject-introspection, gtk3, xrandr, python3Packages }:

let
  inherit (python3Packages) buildPythonApplication docutils pygobject3;
in buildPythonApplication rec {
  name = "arandr-0.1.10";

  src = fetchurl {
    url = "https://christian.amsuess.com/tools/arandr/files/${name}.tar.gz";
    sha256 = "135q0llvm077jil2fr92ssw3p095m4r8jfj0lc5rr3m71n4srj6v";
  };

  patchPhase = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [ docutils ];
  nativeBuildInputs = [ gobject-introspection gtk3 ];
  propagatedBuildInputs = [ xrandr pygobject3 ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
  ];

  meta = {
    homepage = http://christian.amsuess.com/tools/arandr/;
    description = "A simple visual front end for XRandR";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
  };
}
