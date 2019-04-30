{ stdenv, fetchurl, xrandr, python2Packages }:

let
  inherit (python2Packages) buildPythonApplication docutils pygtk;
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
  propagatedBuildInputs = [ xrandr pygtk ];

  meta = {
    homepage = http://christian.amsuess.com/tools/arandr/;
    description = "A simple visual front end for XRandR";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
  };
}
