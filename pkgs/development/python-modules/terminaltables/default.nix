{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "terminaltables";
  version = "3.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-um7KXLW6ArukyfT5ha+AxU7D3M+Uz80ZAVQ4YlXkdUM=";
  };

  meta = {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/Robpol86/terminaltables";
    license = lib.licenses.mit;
  };
})
