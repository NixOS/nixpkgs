{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LSBo+1URWAfTrHekymj6SIA+hOuw7iNA+FgQejZSJjg=";
  };

  meta = with lib; {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    license = licenses.lgpl2;
  };
}
