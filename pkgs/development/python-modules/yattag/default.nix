{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.16.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uqjyVOfqXT4GGCga0v9WEODlNgs2COaVwpv7OynQUfQ=";
  };

  pythonImportsCheck = [ "yattag" ];

  meta = {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
  };
}
