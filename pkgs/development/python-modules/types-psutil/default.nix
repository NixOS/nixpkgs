{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "7.0.0.20250801";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_psutil";
    inherit version;
    hash = "sha256-AjC1YjQlLMb1nDYdzLqqCPMIjqNWk2er5pAEhdOIyX0=";
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
