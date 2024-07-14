{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "terminaltables";
  version = "3.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-um7KXLW6ArukyfT5ha+AxU7D3M+Uz80ZAVQ4YlXkdUM=";
  };

  meta = with lib; {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/Robpol86/terminaltables";
    license = licenses.mit;
  };
}
