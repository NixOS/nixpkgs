{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "10.1.0.20240106";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
    hash = "sha256-0sLtfs5rC+y02vFQ4jdMj02Xf+bv7GJe+VLiYldhkOc=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "PIL-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Pillow";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s ];
  };
}
