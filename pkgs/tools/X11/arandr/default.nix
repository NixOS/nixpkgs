{ stdenv, fetchurl, python, xrandr, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "arandr-0.1.8";

  src = fetchurl {
    url = "http://christian.amsuess.com/tools/arandr/files/${name}.tar.gz";
    sha256 = "0d574mbmhaqmh7kivaryj2hpghz6xkvic9ah43s1hf385y7c33kd";
  };

  patchPhase = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [ pythonPackages.docutils ];
  propagatedBuildInputs = [ xrandr pythonPackages.pygtk ];

  meta = {
    homepage = http://christian.amsuess.com/tools/arandr/;
    description = "A simple visual front end for XRandR";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
