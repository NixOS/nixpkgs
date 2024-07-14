{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "stdiomask";
  version = "0.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-weRwaerZ4QvaFQom95IsoB0q3FAwQqnXrPZId6K5o6Y=";
  };

  # tests are not published: https://github.com/asweigart/stdiomask/issues/5
  doCheck = false;
  pythonImportsCheck = [ "stdiomask" ];

  meta = with lib; {
    description = "Python module for masking passwords";
    homepage = "https://github.com/asweigart/stdiomask";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
