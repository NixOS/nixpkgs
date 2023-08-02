{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "10.0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
    hash = "sha256-/gk4CrItQSztmJoGfp7kr3Gfo6R7obU7IytGUUqHEEI=";
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
