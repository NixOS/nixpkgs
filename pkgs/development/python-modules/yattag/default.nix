{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.16.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uqjyVOfqXT4GGCga0v9WEODlNgs2COaVwpv7OynQUfQ=";
  };

  pythonImportsCheck = [ "yattag" ];

  meta = with lib; {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
