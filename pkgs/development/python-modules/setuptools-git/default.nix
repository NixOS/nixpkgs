{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
}:

buildPythonPackage rec {
  pname = "setuptools-git";
  version = "1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/2QTbaAaq7p2roiwUOcZeRjYshOcy/YUThTUcrnEBEU=";
  };

  propagatedBuildInputs = [ pkgs.git ];
  doCheck = false;

  meta = with lib; {
    description = "Setuptools revision control system plugin for Git";
    homepage = "https://pypi.python.org/pypi/setuptools-git";
    license = licenses.bsd3;
  };
}
