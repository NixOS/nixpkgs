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
    sha256 = "19m3p6i7fj7nmkbsjhiha3f2l7d05j9gf9ha2pd0pqfrx9lp1r61";
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
