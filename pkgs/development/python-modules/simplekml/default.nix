{ lib , buildPythonPackage , fetchPypi }:

buildPythonPackage rec {
  pname = "simplekml";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17h48r1dsfz4g9xcxh1xq85h20hiz7qzzymc1gla96bj2wh4wyv5";
  };

  doCheck = false; # no tests are defined in 1.3.5

  meta = with lib; {
    description = "Generate KML with as little effort as possible";
    homepage =  "https://readthedocs.org/projects/simplekml/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
