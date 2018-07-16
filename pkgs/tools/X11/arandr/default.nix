{ stdenv, fetchurl, xrandr, python2Packages }:

let
  inherit (python2Packages) buildPythonApplication docutils pygtk;
in buildPythonApplication rec {
  name = "arandr-0.1.9";

  src = fetchurl {
    url = "https://christian.amsuess.com/tools/arandr/files/${name}.tar.gz";
    sha256 = "1i3f1agixxbfy4kxikb2b241p7c2lg73cl9wqfvlwz3q6zf5faxv";
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
