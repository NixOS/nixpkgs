{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1fLlOpoA2zIkqMNjSbU4Dg4i0a7GxpSxT7lIPuk8YgU=";
  };

  pythonImportsCheck = [ "unidiff" ];

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    homepage = "https://github.com/matiasb/python-unidiff";
    changelog = "https://github.com/matiasb/python-unidiff/raw/v${version}/HISTORY";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
