{ lib
, buildPythonPackage
, fetchPypi
, freefont_ttf
, glibcLocales
, librsvg
, makeFontsConf
, python
, attrdict
, setuptools_scm
, svgwrite
}:

buildPythonPackage rec {
  pname = "wavedrom";
  version = "0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "006w683zlmmwcw5xz1n5dwg34ims5jg3gl2700ql4wr0myjz6710";
  };
  LC_ALL = "en_US.UTF-8";

  checkInputs = [
    glibcLocales
    librsvg
  ];

  propagatedBuildInputs = [
    attrdict
    setuptools_scm
    svgwrite
  ];

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  postPatch = "patchShebangs .";

  checkPhase = ''
    (cd test && PATH=$out/bin:$PATH ./test.sh)
  '';

  meta = {
    description = "WaveDrom compatible python command line";
    homepage = https://github.com/K4zuki/wavedrompy;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
