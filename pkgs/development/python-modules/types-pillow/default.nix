{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "10.2.0.20240213";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
    hash = "sha256-SAC2G/fqva4vGxet4NCAcJ7TPp8moukA5HDotW6+I4c=";
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
