{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.15.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qtn1QL0i3FA+W1UGzEeFb6zwgapx/TX3JzcbY+HkAr8=";
  };

  pythonImportsCheck = [
    "yattag"
  ];

  meta = with lib; {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
