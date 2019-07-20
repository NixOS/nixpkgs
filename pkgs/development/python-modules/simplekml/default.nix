{ lib , buildPythonPackage , fetchPypi }:

buildPythonPackage rec {
  pname = "simplekml";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30c121368ce1d73405721730bf766721e580cae6fbb7424884c734c89ec62ad7";
  };

  doCheck = false; # no tests are defined in 1.3.1

  meta = with lib; {
    description = "Generate KML with as little effort as possible";
    homepage =  https://readthedocs.org/projects/simplekml/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
