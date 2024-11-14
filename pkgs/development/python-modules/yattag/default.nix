{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CXgke5dU2fRONwPGQ3Srn6hy0Y3pWsV3L9/dPD8NBwY=";
  };

  pythonImportsCheck = [ "yattag" ];

  meta = with lib; {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
