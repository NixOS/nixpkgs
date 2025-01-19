{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "5.9.5.20240516";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uylvWfxWRYiR0P6xmUcX5UihvPiZNqKHffh5K4IrRpY=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "psutil-stubs" ];

  meta = {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
