{
  buildPythonPackage,
  fetchPypi,
  nose,
  lib,
}:

buildPythonPackage rec {
  pname = "xlwt";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c59912717a9b28f1a3c2a98fd60741014b06b043936dcecbc113eaaada156c88";
  };

  nativeCheckInputs = [ nose ];
  checkPhase = ''
    nosetests -v
  '';

  meta = {
    description = "Library to create spreadsheet files compatible with MS";
    homepage = "https://github.com/python-excel/xlwt";
    license = with lib.licenses; [
      bsdOriginal
      bsd3
      lgpl21
    ];
  };
}
