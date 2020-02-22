{ lib , buildPythonPackage , fetchPypi }:

buildPythonPackage rec {
  pname = "simplekml";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08l24gfql83yjcdqb51nnnvckbnfb7bl89am4q9zr0fslrbcn3vf";
  };

  doCheck = false; # no tests are defined in 1.3.3

  meta = with lib; {
    description = "Generate KML with as little effort as possible";
    homepage =  https://readthedocs.org/projects/simplekml/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
