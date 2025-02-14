{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "6.1.0.20241221";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_psutil";
    inherit version;
    hash = "sha256-YA9aNr1eDriIfw4/P/LPFU2QaQrYEjyKcHu6SrlNMYU=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "psutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
