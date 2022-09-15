{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "9.2.0";

  src = fetchPypi {
    pname = "types-Pillow";
    inherit version;
    sha256 = "sha256-aCOFHhedzBV0JBdbXcDhIEsclJ4d4yQX/y+/p+PT9Fs=";
  };

  pythonImportsCheck = [
    "PIL-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Pillow";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
