{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-ujson";
  version = "5.7.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VDUaYuwbZVDvsXr2PvfwwA0O+pwJnefaXGJ+HvooBVM=";
  };

  doCheck = false;

  pythonImportsCheck = [
    "ujson-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}
