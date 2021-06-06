{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "simplekml";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17h48r1dsfz4g9xcxh1xq85h20hiz7qzzymc1gla96bj2wh4wyv5";
  };

  # no tests are defined in 1.3.5
  doCheck = false;
  pythonImportsCheck = [ "simplekml" ];

  meta = with lib; {
    description = "Python package to generate KML";
    homepage =  "https://simplekml.readthedocs.io/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
